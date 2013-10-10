#
# Cookbook Name:: amimoto
# Recipe:: default
#
# Copyright 2013, DigitalCube Co. Ltd.
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'amimoto::timezone'
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
end

%w{ Percona-Server-server-55 Percona-Server-client-55 Percona-Server-shared-compat }.each do |package_name|
  package package_name do
    action [:install, :upgrade]
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
template "/etc/nginx/nginx.conf" do
  variables node[:nginx][:config]
  source "nginx/nginx.conf.erb"
  notifies :reload, 'service[nginx]'
end

%w{ drop expires mobile-detect phpmyadmin wp-multisite-subdir wp-singlesite }.each do | file_name |
  template "/etc/nginx/" + file_name do
    source "nginx/" + file_name + ".erb"
    notifies :reload, 'service[nginx]'
  end
end

%w{ default.conf default.backend.conf }.each do | file_name |
  template "/etc/nginx/conf.d/" + file_name do
    variables(
      :server_name => node[:ec2][:instance_id]
    )
    source "nginx/conf.d/" + file_name + ".erb"
    notifies :reload, 'service[nginx]'
  end
end

%W{ /var/cache/nginx /var/log/nginx /var/www/vhosts/#{node[:ec2][:instance_id]} }.each do | dir_name |
  directory dir_name do
    owner node[:nginx][:config][:user]
    group node[:nginx][:config][:group]
    mode 00755
    recursive true
    action :create
  end
end

service "nginx" do
  action [:enable, :start]
end

# configure php
%w{ apc.ini memcache.ini }.each do | file_name |
  template "/etc/php.d/" + file_name do
    source "php/php.d/" + file_name + ".erb"
    notifies :reload, 'service[php-fpm]'
  end
end

template "/etc/php.ini" do
  source "php/php.ini.erb"
    notifies :reload, 'service[php-fpm]'
end

template "/etc/php-fpm.conf" do
  source "php/php-fpm.conf.erb"
    notifies :reload, 'service[php-fpm]'
end

template "/etc/php-fpm.d/www.conf" do
  variables node[:php][:config]
  source "php/php-fpm.d/www.conf.erb"
  notifies :reload, 'service[php-fpm]'
end

%w{ /var/tmp/php/session /var/log/php-fpm }.each do | dir_name |
  directory dir_name do
    owner node[:php][:config][:user]
    group node[:php][:config][:group]
    mode 00755
    recursive true
    action :create
  end
end

service "php-fpm" do
  action [:enable, :start]
end

# install wp-cli
directory node[:wpcli][:dir] do
  recursive true
end

remote_file "#{node[:wpcli][:dir]}/installer.sh" do
  source 'http://wp-cli.org/installer.sh'
  mode 0755
  action :create_if_missing
end

bin = ::File.join(node[:wpcli][:dir], 'bin', 'wp')

bash 'install wp-cli' do
  code './installer.sh'
  cwd node[:wpcli][:dir]
  environment 'INSTALL_DIR' => node[:wpcli][:dir],
              'VERSION' => node[:wpcli][:version]
  creates bin
end

link node[:wpcli][:link] do
  to bin
end

