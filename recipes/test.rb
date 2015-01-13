google_auth_proxy_install "my-app" do
  client_id "123456.apps.googleusercontent.com"
  client_secret "my_secret"
  google_apps_domains ["mycompany.com"] # Restrict login to a set of Google apps domains
  cookie_domain "my-app.mycompany.com"
  redirect_url "http://my-app.mycompany.com/oauth2/callback"
  listen_address "127.0.0.1:4180"
  upstreams ["http://127.0.0.1:4181/"]
  # bin_path '/usr/bin'
end
