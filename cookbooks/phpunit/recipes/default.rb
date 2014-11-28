#
# Cookbook Name:: phpunit
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
