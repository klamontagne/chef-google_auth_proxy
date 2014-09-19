#
# Cookbook Name:: google_auth_proxy
# Recipe:: default
#

source_address = node[:google_auth_proxy][:source]
bin_checksum = node[:google_auth_proxy][:checksum]

# Install the google_auth_proxy binary ...
if (source_address =~ /^github\.com\/.*/)
  Chef::Log.info("Installing 'google_auth_proxy' via `go get` from: #{source_address}")
  golang_package source_address
elsif (source_address =~ /^http:|^https:|^file:/)
  Chef::Log.info("Installing 'google_auth_proxy' via remote_file from: #{source_address}")
  remote_file "#{node[:go][:gobin]}/google_auth_proxy" do
    source source_address
    owner node[:go][:owner]
    group node[:go][:group]
    mode '0755'
    if bin_checksum
      checksum bin_checksum
    end
  end
else
  Chef::Application.fatal!("Invalid source for 'google_auth_proxy': #{source_address}")
end
