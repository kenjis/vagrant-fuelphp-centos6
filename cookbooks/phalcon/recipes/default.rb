#
# Cookbook Name:: phalcon
# Recipe:: default
#
# Copyright 2014, Kenji Suzuki <https://github.com/kenjis>
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

execute "install build tools for compiling phalcon" do
  user "root"
  command <<-EOL
    yum install -y --enablerepo=remi,remi-php55 php-devel php-mysql gcc libtool re2c
  EOL
end

execute "compile phalcon1" do
  user "root"
  command <<-EOL
    rm -rf cphalcon
    git clone --depth=1 git://github.com/phalcon/cphalcon.git
    cd cphalcon/build
    ./install
    cp -p /usr/lib64/php/modules/phalcon.so /usr/lib64/php/modules/phalcon.so.1
  EOL
  not_if { File.exists?("/usr/lib64/php/modules/phalcon.so.1") }
end

execute "compile phalcon2" do
  user "root"
  command <<-EOL
    rm -rf json-c
    git clone https://github.com/json-c/json-c.git
    cd json-c
    sh autogen.sh
    ./configure
    make
    make install
    cd ..

    rm -rf zephir
    git clone https://github.com/phalcon/zephir.git
    cd zephir
    ./install
    cd ..

    rm -rf cphalcon
    git clone -b 2.0.0 --depth=1 https://github.com/phalcon/cphalcon.git
    cd cphalcon
    cp -p /etc/php.ini /etc/php.ini.backup_for_compiling_cphalcon2
    sed -i -e "s/memory_limit = .*M/memory_limit = 256M/" /etc/php.ini
    ../zephir/bin/zephir build
    cp -p /usr/lib64/php/modules/phalcon.so /usr/lib64/php/modules/phalcon.so.2
    mv /etc/php.ini.backup_for_compiling_cphalcon2 /etc/php.ini
  EOL
  not_if { File.exists?("/usr/lib64/php/modules/phalcon.so.2") }
end

execute "install phalcon1" do
  user "root"
  command <<-EOL
    rm -f /usr/lib64/php/modules/phalcon.so
    ln -s /usr/lib64/php/modules/phalcon.so.1 /usr/lib64/php/modules/phalcon.so
  EOL
end

template "/etc/php.d/phalcon.ini" do
  source "phalcon.ini.erb"
  mode "0644"
  notifies :restart, "service[httpd]"
end

execute "install phalcon devtools" do
  user "root"
  command <<-EOL
    cd /home/vagrant
    rm -rf phalcon-devtools
    git clone https://github.com/phalcon/phalcon-devtools
    ln -s /home/vagrant/phalcon-devtools/phalcon.php /usr/local/bin/phalcon
    chmod ugo+x /usr/local/bin/phalcon
  EOL
  not_if { File.exists?("/usr/local/bin/phalcon") }
end
