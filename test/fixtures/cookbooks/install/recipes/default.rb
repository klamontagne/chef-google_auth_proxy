include_recipe 'google_auth_proxy'  

google_auth_proxy_install 'test_proxy' do
  client_id           'client_id'
  client_secret       'client_secret'
  google_apps_domain  'example.com'
  cookie_domain       'cookies.example.com'
  redirect_url        'redirect.example.com'
  upstream            ['upstream.example.com']
end
