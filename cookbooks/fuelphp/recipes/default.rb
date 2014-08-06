#
# Cookbook Name:: fuelphp
# Recipe:: default
#
# Copyright 2013, Kenji Suzuki <https://github.com/kenjis>
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

service "iptables" do
  action [:stop, :disable]
end

service "httpd" do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
end

template "/etc/httpd/conf.d/fuelphp.conf" do
  source "web_app.conf.erb"
  mode "0644"
  notifies :restart, "service[httpd]"
end

# install git
yum_package "git" do
  action :install
end

yum_package "bash-completion" do
  action :install
end

# install oil command
execute "install fuelphp oil command" do
  command "curl get.fuelphp.com/oil | sh"
  user "root"
end

# install composer
execute "install composer" do
  command <<-EOL
    curl -sS https://getcomposer.org/installer | php
    mv composer.phar /usr/local/bin/composer
    chown vagrant.vagrant /usr/local/bin/composer
  EOL
  user "root"
  not_if { File.exists?("/usr/local/bin/composer") }
end

# install phpunit
execute "install phpunit" do
  # FIXME
  # command "composer global require 'phpunit/phpunit=3.7.*'"
  # does not work. The below error occurs.
  #   STDERR: [ErrorException]
  #   chdir(): No such file or directory (errno 2)
  command <<-EOL
    mkdir -p /home/vagrant/.composer
    cd /home/vagrant/.composer
    composer require 'phpunit/phpunit=3.7.*'
  EOL
  user "vagrant"
  not_if { File.exists?("/home/vagrant/.composer/vendor/bin/phpunit") }
end

# set composer path
execute "set global composer bin path" do
  command <<-EOL
    sed -i -e '/\.composer/d' /home/vagrant/.bash_profile
    sed -i -e '/export PATH/d' /home/vagrant/.bash_profile
    echo 'PATH="$HOME/.composer/vendor/bin:$PATH"' >>/home/vagrant/.bash_profile
    echo 'export PATH' >>/home/vagrant/.bash_profile
  EOL
  user "vagrant"
end

# create the databases
node[:db].each do |name|
  execute "create database #{name}" do
    command "mysql -uroot -p#{node[:mysql][:server_root_password]} -e 'create database if not exists #{name}'"
    user "vagrant"
  end
end

# add a quick symlink
link "/home/vagrant/fuelphp" do
  to "/mnt/fuelphp"
end

# install script to remount /mnt/fuelphp for changing gid
template "/etc/init.d/remount-mnt-fuelphp" do
  source "remount-mnt-fuelphp.erb"
  mode "0755"
end

# install upstart conf file to run /etc/init.d/remount-mnt-fuelphp
template "/etc/init/remount-mnt-fuelphp.conf" do
  source "remount-mnt-fuelphp.conf.erb"
  mode "0644"
end

# remount /mnt/fuelphp
execute "remount /mnt/fuelphp for changing permission" do
  command <<-EOL
    /etc/init.d/remount-mnt-fuelphp
  EOL
  user "root"
end

#execute "yum update" do
#  user "root"
#  command "yum -y update"
#end

# install FuelPHP if not exists
execute "install fuelphp" do
  command <<-EOL
    cd /home/vagrant
    oil create fuel.tmp
    shopt -s dotglob
    mv fuel.tmp/* fuelphp
    rmdir fuel.tmp
  EOL
  user "vagrant"
  not_if { File.exists?("/home/vagrant/fuelphp/oil") }
end
