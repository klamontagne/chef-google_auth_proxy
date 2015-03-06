

actions :run
default_action :run

attribute :client_id, kind_of: String
attribute :client_secret, kind_of: String
attribute :cookie_domain, kind_of: String
attribute :cookie_secret, kind_of: String
attribute :cookie_expire, kind_of: String
attribute :cookie_https_only, kind_of: [TrueClass, FalseClass], default: true
attribute :cookie_httponly, kind_of: [TrueClass, FalseClass], default: true

attribute :user, kind_of: String, default: 'www-data'

attribute :google_apps_domains, kind_of: Array
attribute :listen_address, kind_of: String, default: '127.0.0.1:4180'
attribute :redirect_url, kind_of: String

attribute :upstreams, kind_of: Array, default: '127.0.0.1:4181'

attribute :pass_basic_auth, kind_of: [TrueClass, FalseClass], default: true
attribute :authenticated_emails_file, kind_of: String
attribute :htpasswd_file, kind_of: String
