google_auth_proxy Cookbook
==========================

This cookbook sets up a [Google Auth Proxy](https://github.com/bitly/google_auth_proxy) instance provider.

Dependencies
------------

This cookbook needs `golang` and **must have Go version 1.1.1+**

It only supports Upstart as a service provider at the moment.

How to use the provider
-----------------------
```ruby
include_recipe "google_auth_proxy"
# Proxy definition example
# Get your own keys at https://code.google.com/apis/console
google_auth_proxy_install "my-app" do
  client_id "123456.apps.googleusercontent.com"
  client_secret "my_secret"
  google_apps_domains ["mycompany.com"] # Restrict login to a set of Google apps domains
  cookie_domain "my-app.mycompany.com"
  redirect_url "http://my-app.mycompany.com/oauth2/callback"
  listen_address "127.0.0.1:4180"
  upstreams ["http://127.0.0.1:4181/"]
end
```

The cookie secret will be stored as a node attribute, one for each resource name, under `[:google_auth][:cookie_secret]`.

An Upstart service for the proxy will be created as `google_auth_proxy_my-app`.

nginx example vhost config
--------------------

For more details, see the README of [Google Auth Proxy](https://github.com/bitly/google_auth_proxy).

```
# Send everything through the Google Auth Proxy
server {
    listen 0.0.0.0:80;

    server_name           my-app.mycompany.com;
    access_log            /var/log/nginx/my-app.mycompany.com.access.log;

    location / {
        proxy_pass http://127.0.0.1:4180;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Scheme $scheme;
        proxy_connect_timeout 1;
        proxy_send_timeout 30;
        proxy_read_timeout 30;
    }
}

# The actual service
server {
  listen                127.0.0.1:4181;

  location / {
    root  /var/www;
    index  index.html  index.htm; 
  }
```


License and Authors
-------------------
Authors: De Marque Inc.
