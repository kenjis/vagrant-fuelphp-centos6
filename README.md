# FuelPHP Vagrant Development setup (CentOS6)

[日本語](README.ja.md)

This project sets up a CentOS 6.5 (64bit) virtual machine to run your FuelPHP project in.  It mounts your FuelPHP project directory so that you can use your favorite editors to work.

## Requirements

* VirtualBox - Free virtualization software [Download Virtualbox](https://www.virtualbox.org/wiki/Downloads)
* Vagrant 1.3+ - Tool for working with VirtualBox images [Download Vagrant](http://downloads.vagrantup.com/)
* Git - Version control system [Download Git](http://git-scm.com/downloads)

### Tested

* Ubuntu 12.04 - VirtualBox 4.2.18 & Vagrant 1.5.0 & Git 1.7.9.5
* Mac OS X 10.8.5 - VirtualBox 4.3.6 & Vagrant 1.4.3 & Git 1.8.4.1

## What's in the Development environment?

Some of the following are including using Chef Opscode repositories.

* PHP 5.4
* Apache 2.2
  * vhost setup for your project
* MySQL 5.1
  * **fuel_dev** and **fuel_test** databases
* phpMyAdmin 3.5
* PHPUnit 3.7
* Git 1.7.1

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

* **Browser by Port Forwarding**: [http://localhost:8000](http://localhost:8000)
* **Browser by IP Address**: [http://192.168.33.33](http://192.168.33.33)
* **MySQL**: mysql:host=192.168.33.33;dbname=fuel_dev (root user password is set in the Vagrantfile)

### Vagrant

Here are a few common commands:

* `vagrant up` starts the virtual machine and provisions it
* `vagrant suspend` will save the current running state of the machine and stop it
* `vagrant halt` attempts a graceful shutdown of the machine
* `vagrant ssh` gives you SSH access to the virtual machine

More in http://docs.vagrantup.com/v2/

## Thanks to

* https://github.com/iturgeon/vagrant-fuelphp
