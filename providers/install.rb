require 'securerandom'

action :run do
  use_inline_resources if defined?(use_inline_resources)

  service_name = new_resource.name

  # Create cookie secret
  unless node.attribute? "google_auth.cookie_secret.#{service_name}"
    node.set_unless['google_auth']['cookie_secret'][service_name] = SecureRandom.base64 34
    node.save unless Chef::Config[:solo]
  end

  directory '/etc/google_auth_proxy' do
    owner 'root'
    group 'root'
    mode 0755
  end

  case node['google_auth_proxy']['install_method']
  when 'source'

    golang_package node['google_auth_proxy']['source_golange_package']

    link 'google_auth_proxy' do
      to "#{node['go']['gopath']}/google_auth_proxy"
      target_file "#{node['google_auth_proxy']['bin_path']}/google_auth_proxy"
    end

  when 'binary'

    file_name = ::File.join(Chef::Config[:file_cache_path], 'google_auth_proxy.tar.gz')

    remote_file file_name  do
      source node['google_auth_proxy']['binary_url']
      checksum node['google_auth_proxy']['binary_checksum']
      notifies :run, 'bash[install google_auth_proxy binary]', :immediate
    end

    bash 'install google_auth_proxy binary' do
      action :nothing
      cwd Chef::Config[:file_cache_path]
      code <<-EOH
      tar xzf #{file_name}
      install -m 0755 -o root -g root #{node['google_auth_proxy']['archive_path']} #{node['google_auth_proxy']['bin_path']}
      EOH
    end

  else
    Chef::Application.fatal!("node[:google_auth_proxy][:install_method] has an unknown value: #{node[:google_auth_proxy][:install_method]}")
  end

  template "/etc/google_auth_proxy/#{service_name}.conf" do
    source 'proxy.conf.erb'
    cookbook 'google_auth_proxy'
    mode 0640
    owner new_resource.user
    group 'root'
    variables(
      client_id: new_resource.client_id,
      client_secret: new_resource.client_secret,
      cookie_domain: new_resource.cookie_domain,
      cookie_secret: node['google_auth']['cookie_secret'][service_name],
      cookie_expire: node['google_auth_proxy']['cookie_expire'],
      cookie_https_only: node['google_auth_proxy']['cookie_https_only'],
      cookie_httponly: node['google_auth_proxy']['cookie_httponly'],
      google_apps_domains: new_resource.google_apps_domains,
      listen_address: new_resource.listen_address,
      redirect_url: new_resource.redirect_url,
      upstreams: new_resource.upstreams,
      pass_basic_auth: node['google_auth_proxy']['pass_basic_auth'],
      authenticated_emails_file: node['google_auth_proxy']['authenticated_emails_file'],
      htpasswd_file: node['google_auth_proxy']['htpasswd_file']
    )
  end

  template "#{service_name}-upstart" do
    path "/etc/init/google_auth_proxy_#{service_name}.conf"
    source 'upstart.conf.erb'
    cookbook 'google_auth_proxy'
    owner 'root'
    group 'root'
    mode 0644
    variables(
      user: new_resource.user,
      service_name: service_name
    )
  end

  service "google_auth_proxy_#{service_name}" do
    provider Chef::Provider::Service::Upstart
    action [:enable, :start]
    supports status: true, restart: false, reload: false
    if node['google_auth_proxy']['auto_restart']
      subscribes :restart, "template[#{service_name}-upstart]", :delayed
      subscribes :restart, "template[/etc/google_auth_proxy/#{service_name}.conf]", :delayed
    end
  end
end
