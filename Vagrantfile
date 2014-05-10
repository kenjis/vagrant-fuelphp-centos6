# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "CentOS-6.5-x86_64"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  config.vm.box_url = "http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.5-x86_64-v20140311.box"
  #config.vm.box_url = "http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.4-x86_64-v20130731.box"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8000" will access port 80 on the guest machine.
  config.vm.network :forwarded_port, guest: 80, host: 8000

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network :private_network, ip: "192.168.33.33"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network :public_network

  # If true, then any SSH connections made will enable agent forwarding.
  # Default value: false
  # config.ssh.forward_agent = true

  # Mount the parent directory at /mnt/fuelphp
  config.vm.synced_folder "../", "/mnt/fuelphp",
    :owner => "vagrant", :group => "vagrant",
    :mount_options => ["dmode=777,fmode=666"]
  # Speed up with NFS. nfsd is needed on Host OS
  #config.vm.synced_folder "../", "/mnt/fuelphp", :nfs => true

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider :virtualbox do |vb|
  #   # Don't boot with headless mode
  #   vb.gui = true
  #
  #   # Use VBoxManage to customize the VM. For example to change memory:
  #   vb.customize ["modifyvm", :id, "--memory", "1024"]
  # end
  #
  # View the documentation for the provider you're using for more
  # information on available options.

  # Enable provisioning with chef solo, specifying a cookbooks path, roles
  # path, and data_bags path (all relative to this Vagrantfile), and adding
  # some recipes and/or roles.
  #
  config.vm.provision :chef_solo do |chef|
     chef.cookbooks_path = "./cookbooks"

     # PHP 5.5 for production
     chef.add_recipe "yum::ius"
     chef.add_recipe "php55"
     #chef.add_recipe "php54"

     # PHP 5.6 for testing
     #chef.add_recipe "yum-remi"
     #chef.add_recipe "php56-remi"

     chef.add_recipe "mysql::server"
     chef.add_recipe "phpmyadmin"
     chef.add_recipe "fuelphp"
 
  #   # You may also specify custom JSON attributes:
     chef.json = {
        "php55" => {
            "date.timezone" => "Asia/Tokyo"
        },
        "mysql" => {
           "server_root_password"   => "root",
           'server_debian_password' => "root",
           'server_repl_password'   => "root",
           "allow_remote_root"      => true, # allows us to connect from the host
           "bind_address"           => "0.0.0.0",
         },
         # which databases should we make?
         "db" => [
           "fuel_test",
           "fuel_dev"
         ],
      }
  end
end
