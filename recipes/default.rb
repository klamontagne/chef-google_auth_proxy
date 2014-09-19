#
# Cookbook Name:: google_auth_proxy
# Recipe:: default
#

source_address = node[:google_auth_proxy][:source]

# Install the google_auth_proxy binary ...
if (source_address =~ /^github\.com\/.*/)
  Chef::Log.info("Installing 'google_auth_proxy' via `go get` from: #{source_address}")
  golang_package source_address
elsif (source_address =~ /^http:|^https:|^file:/)
  Chef::Log.info("Installing 'google_auth_proxy' via remote_file from: #{source_address}")
  remote_file source_address do
    path "#{node[:go][:gobin]/google_auth_proxy}"
    owner node[:go][:owner]
    group node[:go][:group]
    mode '0755'
  end
else
  Chef::Log.fatal("Invalid source for 'google_auth_proxy': #{source_address}")
end
