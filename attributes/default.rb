
# binary or source
default['google_auth_proxy']['install_method'] = 'binary'

default['google_auth_proxy']['archive_path'] = 'google_auth_proxy-1.0.linux-amd64.go1.3/google_auth_proxy'
default['google_auth_proxy']['bin_path'] = '/usr/bin'
default['google_auth_proxy']['binary_checksum'] = '2928de1b7a4f6ad6dc119e44ecdef14032de3a454baa25dd342aa257e8ea7ae9'
default['google_auth_proxy']['binary_url'] = 'https://github.com/bitly/google_auth_proxy/releases/download/v1.0/google_auth_proxy-1.0.linux-amd64.go1.3.tar.gz'
default['google_auth_proxy']['source_golange_package'] = 'github.com/bitly/google_auth_proxy'

default['google_auth_proxy']['auto_restart'] = true

default['google_auth_proxy']['cookie_expire'] = '168h'
default['google_auth_proxy']['cookie_https_only'] = true
default['google_auth_proxy']['cookie_httponly'] = true
default['google_auth_proxy']['pass_basic_auth'] = true
default['google_auth_proxy']['authenticated_emails_file'] = ''
default['google_auth_proxy']['htpasswd_file'] = ''
