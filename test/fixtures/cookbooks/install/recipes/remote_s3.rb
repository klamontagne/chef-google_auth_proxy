include_recipe 'google_auth_proxy'  

if node[:google_auth_proxy][:source] == 'github.com/bitly/google_auth_proxy'
  Chef::Application.fatal!("Please change the [:google_auth_proxy][:source] attribute!")
end

google_auth_proxy_install 'test_proxy' do
  client_id           'client_id'
  client_secret       'client_secret'
  google_apps_domain  'example.com'
  cookie_domain       'cookies.example.com'
  redirect_url        'redirect.example.com'
  upstream            ['upstream.example.com']
end
