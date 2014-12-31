require 'securerandom'

action :run do

  use_inline_resources if defined?(use_inline_resources)

  service_name = new_resource.name

  # Create cookie secret
  unless node.attribute? "google_auth.cookie_secret.#{service_name}"
    node.set_unless['google_auth']['cookie_secret'][service_name] = SecureRandom.base64 34
    node.save unless Chef::Config[:solo]
  end

  golang_package 'github.com/bitly/google_auth_proxy'

  directory '/etc/google_auth_proxy' do
    owner 'root'
    group 'root'
    mode 0755
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
      google_apps_domains: new_resource.google_apps_domains,
      listen_address: new_resource.listen_address,
      redirect_url: new_resource.redirect_url,
      upstreams: new_resource.upstreams
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
    subscribes :restart, "template[#{service_name}-upstart]", :delayed
  end

end
