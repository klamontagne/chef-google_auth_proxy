action :run do

  service_name = "google_auth_proxy_#{new_resource.name}"

  golang_package "github.com/klamontagne/google_auth_proxy"
  
  template "/etc/init/#{service_name}.conf" do
    source "upstart.conf.erb"
    mode 0600
    owner "root"
    cookbook "google_auth_proxy"
    variables(
      :client_id => new_resource.client_id,
      :client_secret => new_resource.client_secret,
      :cookie_domain => new_resource.cookie_domain,
      :cookie_secret => new_resource.cookie_secret,
      :user => new_resource.user,
      :google_apps_domain => new_resource.google_apps_domain,
      :listen_address => new_resource.listen_address,
      :redirect_url => new_resource.redirect_url,
      :upstreams => new_resource.upstream.first #TODO test multiple upstreams
    )
  end

  service service_name do
    provider Chef::Provider::Service::Upstart
    action [ :enable, :start ]
  end

end


