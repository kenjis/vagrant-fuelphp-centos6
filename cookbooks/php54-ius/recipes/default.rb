#
# Cookbook Name:: php54
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

execute "remove php packages" do
  user "root"
  command <<-EOL
    yum -y erase php-*
    yum -y erase php55u-*
  EOL
end

%w(php54 php54-mbstring php54-gd php54-mcrypt php54-mysqlnd php54-pear php54-xml php54-pecl-xdebug).each do |package|
  yum_package package do
    action :install
  end
end

template "/etc/php.ini" do
  source "php.ini.erb"
  mode "0644"
  notifies :restart, "service[httpd]"
end

template "/etc/php.d/xdebug.ini" do
  source "xdebug.ini.erb"
  mode "0644"
  notifies :restart, "service[httpd]"
end
