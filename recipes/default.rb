#
# Cookbook Name:: amimoto
# Recipe:: default
#
# Copyright 2013, DigitalCube Co. Ltd.
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'amimoto::timezone'
include_recipe 'amimoto::sysctl'
include_recipe 'amimoto::repos'
template "/etc/sysconfig/i18n" do
  source "i18n.erb"
end

%w{ zip unzip wget iptables git }.each do | pkg |
  package pkg do
    action [:install, :upgrade]
  end
end

# memcached install
package 'memcached' do
  action [:install, :upgrade]
end

service 'memcached' do
  action node[:memcached][:service_action]
end

# Percona install
cookbook_file "#{Chef::Config[:file_cache_path]}/percona-release-0.0-1.x86_64.rpm" do
  source "percona-release-0.0-1.x86_64.rpm"
end

package "percona-release" do
  source "#{Chef::Config[:file_cache_path]}/percona-release-0.0-1.x86_64.rpm"
  action :install
  provider Chef::Provider::Package::Rpm
  ignore_failure true
end

if ['redhat'].include?(node[:platform])
  %w{ Percona-Server-server-55 Percona-Server-client-55 }.each do |package_name|
    yum_package package_name do
      action [:install, :upgrade]
      flush_cache [:before]
    end
  end
else
  %w{ Percona-Server-server-55 Percona-Server-client-55 Percona-Server-shared-compat }.each do |package_name|
    package package_name do
      action [:install, :upgrade]
    end
  end
end

# nginx install
service "httpd" do
  action [:stop, :disable]
end
package "nginx" do
  action [:install, :upgrade]
end

# php54 install
%w{ php54 php54-cli php54-fpm php54-devel php54-mbstring php54-gd php-pear php54-xml php54-mcrypt php54-mysqlnd php54-pdo php54-pecl-apc php54-pecl-memcache }.each do | pkg |
  package pkg do
    action [:install, :upgrade]
  end
end

# configure mysql
include_recipe 'amimoto::mysql'

# configure nginx
include_recipe 'amimoto::nginx'

# configure php
include_recipe 'amimoto::php'

# install wp-cli
include_recipe 'amimoto::wpcli'

# install monit
include_recipe 'amimoto::monit'
