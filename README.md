# FuelPHP Vagrant Development setup (CentOS6)

This project sets up a CentOS 6.4 (64bit) virtual machine to run your FuelPHP project in.  It mounts your fuelphp project directory so that you can use your favorite editors to work.

## Requirement

* VirtualBox - Free virtualization software [Download Virtualbox](https://www.virtualbox.org/wiki/Downloads)
* Vagrant **1.3+** - Tool for working with VirtualBox images [Download Vagrant](http://downloads.vagrantup.com/)
* Git - Version control system [Download Git](http://git-scm.com/downloads)

## What's in the Development environment?

Some of the following are including using Chef Opscode repositories.

* php5.4
* apache2
* mysql
* **fuel_dev** and **fuel_test** databases
* vhost setup for your project

## Suggesting Setup & Layout

Add this vagrant-fuelphp-centos6 to your project:

	$ git submodule add git@github.com:kenjis/vagrant-fuelphp-centos6.git vagrant
	$ git submodule update --init --recursive
	$ cd vagrant
	$ vagrant up

Setup your directories something like this:

	project/
	project/fuel
	project/public/
	project/vagrant/

## Accessing your project

* **Browser**: [http://localhost:8000](http://localhost:8000)
* **Browser by IP**: [http://192.168.33.33](http://192.168.33.33)
* **Mysql**: mysql:host=192.168.33.33;dbname=fuel_dev (root user password is set in the Vagrantfile)

### Vagrant

Here are a few common commands:

* `vagrant up` starts the virtual machine and provisions it
* `vagrant suspend` will save the current running state of the machine and stop it
* `vagrant halt` attempts a graceful shutdown of the machine
* `vagrant ssh` gives you SSH access to the virtual machine

More in http://docs.vagrantup.com/v2/

## Thanks to

* https://github.com/iturgeon/vagrant-fuelphp
