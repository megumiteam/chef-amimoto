#
# Cookbook Name:: amimoto
# Recipe:: default
#
# Copyright 2013, DigitalCube Co. Ltd.
#
# All rights reserved - Do Not Redistribute
#
instance_type = node[:ec2][:instance_type]

include_recipe 'amimoto::timezone'

case instance_type
when "t1.micro"
	nginx_worker_processes = "2"
	php_max_children = "5"
	php_start_servers = "1"
	php_min_spare_servers = "1"
	php_max_spare_servers = "4"
	php_max_requests = "200"
	mysql_innodb_buffer_pool_size = "64M"
	mysql_query_cache_size = "64M"
	mysql_tmp_table_size = "64M"
	mysql_tmp_table_size = "64M"
	mysql_max_connections = "128"
	mysql_thread_cache = "128"
when "m1.large"
	nginx_worker_processes = "4"
	php_max_children = "5"
	php_start_servers = "1"
	php_min_spare_servers = "1"
	php_max_spare_servers = "4"
	php_max_requests = "200"
	mysql_innodb_buffer_pool_size = "128M"
	mysql_query_cache_size = "128M"
	mysql_tmp_table_size = "128M"
	mysql_tmp_table_size = "128M"
	mysql_max_connections = "128"
	mysql_thread_cache = "128"
else
	nginx_worker_processes = "2"
	php_max_children = "5"
	php_start_servers = "1"
	php_min_spare_servers = "1"
	php_max_spare_servers = "4"
	php_max_requests = "200"
	mysql_innodb_buffer_pool_size = "64M"
	mysql_query_cache_size = "64M"
	mysql_tmp_table_size = "64M"
	mysql_tmp_table_size = "64M"
	mysql_max_connections = "128"
	mysql_thread_cache = "128"
end

%w{ memcached zip unzip wget iptables git }.each do | pkg |
	package pkg do
		action [:install, :upgrade]
	end
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

# nginx install
service "httpd" do
	action [:stop, :disable]
end

package "nginx" do
	action [:install, :upgrade]
end

# configure mysql
service "mysql" do
	action :stop
end

%w{ ib_logfile0 ib_logfile1 }.each do | file_name |
	file "/var/lib/mysql/" + file_name do
		action :delete
	end
end

template "/etc/my.cnf" do
	variables(
		:innodb_buffer_pool_size => mysql_innodb_buffer_pool_size,
		:query_cache_size => mysql_query_cache_size,
		:tmp_table_size => mysql_tmp_table_size,
		:max_connections => mysql_max_connections,
		:thread_cache => mysql_thread_cache
	)
	source "my.cnf.erb"
end

service "mysql" do
	action [:enable, :start]
end

# configure nginx
template "/etc/nginx/nginx.conf" do
	variables(
		:worker_processes => nginx_worker_processes
	)
	source "nginx.conf.erb"
end

%w{ drop expires mobile-detect phpmyadmin wp-multisite-subdir wp-singlesite }.each do | file_name |
	template "/etc/nginx/" + file_name do
		source file_name + ".erb"
	end
end

%w{ default.conf default.backend.conf }.each do | file_name |
	template "/etc/nginx/conf.d/" + file_name do
		variables(
			:server_naem => "default"
		)
		source file_name + ".erb"
	end
end

%w{ /var/cache/nginx /var/log/nginx }.each do | dir_name |
	directory dir_name do
		owner node[:nginx][:user]
		group node[:nginx][:group]
		mode 00644
		recursive true
		action :create
	end
end

service "nginx" do
	action [:enable, :restart]
end

# configure php
%w{ apc.ini memcache.ini }.each do | file_name |
	template "/etc/php.d/" + file_name do
		source file_name + ".erb"
	end
end

template "/etc/php.ini" do
	variables(
		:timezone => node[:timezone]
	)
	source "php.ini.erb"
end

template "/etc/php-fpm.conf" do
	source "php-fpm.conf.erb"
end

template "/etc/php-fpm.d/www.conf" do
	variables(
		:max_children => php_max_children,
		:start_servers => php_start_servers,
		:min_spare_servers => php_min_spare_servers,
		:max_spare_servers => php_max_spare_servers,
		:max_requests => php_max_requests
	)
	source "www.conf.erb"
end

%w{ /var/tmp/php/session /var/log/php-fpm }.each do | dir_name |
	directory dir_name do
		owner node[:php][:user]
		group node[:php][:group]
		mode 00644
		recursive true
		action :create
	end
end

service "php-fpm" do
	action [:enable, :restart]
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

