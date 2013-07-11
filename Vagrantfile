# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "precise64"
  # port for Solr 4.1.2
  config.vm.network :forwarded_port, guest: 8080, host: 9090
  # port for REDIS database
  config.vm.network :forwarded_port, guest: 6379, host: 9999
  # port for POSTGRESQL database
  config.vm.network :forwarded_port, guest: 5432, host: 9900

  ## For masterless, mount your salt file root
  config.vm.synced_folder "salt/roots/", "/srv/"

  ## Use all the defaults:
  config.vm.provision :salt do |salt|
    salt.minion_config = "salt/minion"
    salt.run_highstate = true
    salt.verbose = true
  end
end
