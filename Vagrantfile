# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = '2'
Vagrant.require_version '>= 1.5.0'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.hostname = 'google-auth-proxy-berkshelf'
  config.omnibus.chef_version = :latest
  config.vm.box = 'chef/ubuntu-12.04'
  # config.vm.box_url = "https://vagrantcloud.com/chef/ubuntu-14.04/version/1/provider/virtualbox.box"
  config.vm.network 'private_network', ip: '192.168.50.17'
  config.berkshelf.enabled = true
  config.berkshelf.berksfile_path = './Berksfile'

  config.vm.synced_folder './', '/srv', type: 'nfs' # , owner: "vagrant", group: "vagrant",
  config.nfs.map_uid = Process.uid
  config.nfs.map_gid = Process.gid

  config.vm.provision :chef_solo do |chef|
    chef.log_level = :info
    chef.json = {
      go: {
        version: '1.3'
      },
      google_auth_proxy: {
        # install_method: 'source'
        install_method: 'binary',
        bin_path: '/usr/sbin'
      }
    }

    chef.run_list = [
      'apt',
      'build-essential',
      'git',
      'golang',
      'google_auth_proxy::test'
    ]
  end
end
