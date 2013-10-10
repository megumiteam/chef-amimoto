## memcached
default[:memcached][:service_action] = [:enable, :start]

## Nginx
default[:nginx][:config][:user] = 'nginx'
default[:nginx][:config][:group] = 'nginx'
default[:nginx][:config][:worker_processes] = '2'
default[:nginx][:config][:client_max_body_size] = '4M'
default[:nginx][:config][:proxy_read_timeout] = '90'

## PHP
default[:php][:config][:user] = 'nginx'
default[:php][:config][:group] = 'nginx'
default[:php][:config][:max_children] = '5'
default[:php][:config][:start_servers] = '1'
default[:php][:config][:min_spare_servers] = '1'
default[:php][:config][:max_spare_servers] = '4'
default[:php][:config][:max_requests] = '200'
default[:php][:config][:upload_max_filesize] = node[:nginx][:config][:client_max_body_size]
default[:php][:config][:post_max_size] = node[:php][:config][:upload_max_filesize]
default[:php][:config][:request_terminate_timeout] = node[:nginx][:config][:proxy_read_timeout]
default[:php][:config][:max_execution_time] = node[:nginx][:config][:proxy_read_timeout]

## MySQL
default[:mysql][:config][:user] = 'mysql'
default[:mysql][:config][:innodb_buffer_pool_size] = '64M'
default[:mysql][:config][:innodb_log_file_size] = '16M'
default[:mysql][:config][:query_cache_size] = '64M'
default[:mysql][:config][:tmp_table_size]  = '64M'
default[:mysql][:config][:max_connections] = '128'
default[:mysql][:config][:thread_cache] = '128'

case node[:ec2][:instance_type]
when "t1.micro"
  ## memcached
  default[:memcached][:service_action] = [:stop, :disable]

  ## Nginx
  default[:nginx][:config][:worker_processes] = '2'

  ## PHP
  default[:php][:config][:max_children] = '5'
  default[:php][:config][:start_servers] = '1'
  default[:php][:config][:min_spare_servers] = '1'
  default[:php][:config][:max_spare_servers] = '4'
  default[:php][:config][:max_requests] = '200'

  ## MySQL
  default[:mysql][:config][:innodb_buffer_pool_size] = '64M'
  default[:mysql][:config][:query_cache_size] = '64M'
  default[:mysql][:config][:tmp_table_size]  = '64M'
  default[:mysql][:config][:max_connections] = '128'
  default[:mysql][:config][:thread_cache] = '128'
when "m1.small"
  ## Nginx
  default[:nginx][:config][:worker_processes] = '1'

  ## PHP
  default[:php][:config][:max_children] = '5'
  default[:php][:config][:start_servers] = '1'
  default[:php][:config][:min_spare_servers] = '1'
  default[:php][:config][:max_spare_servers] = '4'
  default[:php][:config][:max_requests] = '200'

  ## MySQL
  default[:mysql][:config][:innodb_buffer_pool_size] = '128M'
  default[:mysql][:config][:query_cache_size] = '128M'
  default[:mysql][:config][:tmp_table_size]  = '128M'
  default[:mysql][:config][:max_connections] = '128'
  default[:mysql][:config][:thread_cache] = '128'
when "m1.large"
  ## Nginx
  default[:nginx][:config][:worker_processes] = '2'

  ## PHP
  default[:php][:config][:max_children] = '20'
  default[:php][:config][:start_servers] = '4'
  default[:php][:config][:min_spare_servers] = '4'
  default[:php][:config][:max_spare_servers] = '16'
  default[:php][:config][:max_requests] = '200'

  ## MySQL
  default[:mysql][:config][:innodb_buffer_pool_size] = '256M'
  default[:mysql][:config][:query_cache_size] = '256M'
  default[:mysql][:config][:tmp_table_size]  = '256M'
  default[:mysql][:config][:max_connections] = '256'
  default[:mysql][:config][:thread_cache] = '256'
when "m1.xlarge"
  ## Nginx
  default[:nginx][:config][:worker_processes] = '4'

  ## PHP
  default[:php][:config][:max_children] = '35'
  default[:php][:config][:start_servers] = '10'
  default[:php][:config][:min_spare_servers] = '10'
  default[:php][:config][:max_spare_servers] = '25'
  default[:php][:config][:max_requests] = '200'

  ## MySQL
  default[:mysql][:config][:innodb_buffer_pool_size] = '256M'
  default[:mysql][:config][:query_cache_size] = '256M'
  default[:mysql][:config][:tmp_table_size]  = '256M'
  default[:mysql][:config][:max_connections] = '256'
  default[:mysql][:config][:thread_cache] = '256'
when "m2.xlarge"
  ## Nginx
  default[:nginx][:config][:worker_processes] = '4'

  ## PHP
  default[:php][:config][:max_children] = '35'
  default[:php][:config][:start_servers] = '10'
  default[:php][:config][:min_spare_servers] = '10'
  default[:php][:config][:max_spare_servers] = '25'
  default[:php][:config][:max_requests] = '200'

  ## MySQL
  default[:mysql][:config][:innodb_buffer_pool_size] = '512M'
  default[:mysql][:config][:query_cache_size] = '512M'
  default[:mysql][:config][:tmp_table_size]  = '512M'
  default[:mysql][:config][:max_connections] = '256'
  default[:mysql][:config][:thread_cache] = '256'
when "m2.2xlarge"
  ## Nginx
  default[:nginx][:config][:worker_processes] = '4'

  ## PHP
  default[:php][:config][:max_children] = '35'
  default[:php][:config][:start_servers] = '10'
  default[:php][:config][:min_spare_servers] = '10'
  default[:php][:config][:max_spare_servers] = '25'
  default[:php][:config][:max_requests] = '200'

  ## MySQL
  default[:mysql][:config][:innodb_buffer_pool_size] = '512M'
  default[:mysql][:config][:query_cache_size] = '512M'
  default[:mysql][:config][:tmp_table_size]  = '512M'
  default[:mysql][:config][:max_connections] = '256'
  default[:mysql][:config][:thread_cache] = '256'
when "m2.4xlarge"
  ## Nginx
  default[:nginx][:config][:worker_processes] = '8'

  ## PHP
  default[:php][:config][:max_children] = '35'
  default[:php][:config][:start_servers] = '10'
  default[:php][:config][:min_spare_servers] = '10'
  default[:php][:config][:max_spare_servers] = '25'
  default[:php][:config][:max_requests] = '200'

  ## MySQL
  default[:mysql][:config][:innodb_buffer_pool_size] = '512M'
  default[:mysql][:config][:query_cache_size] = '512M'
  default[:mysql][:config][:tmp_table_size]  = '512M'
  default[:mysql][:config][:max_connections] = '256'
  default[:mysql][:config][:thread_cache] = '256'
when "m3.xlarge"
  ## Nginx
  default[:nginx][:config][:worker_processes] = '4'

  ## PHP
  default[:php][:config][:max_children] = '35'
  default[:php][:config][:start_servers] = '10'
  default[:php][:config][:min_spare_servers] = '10'
  default[:php][:config][:max_spare_servers] = '25'
  default[:php][:config][:max_requests] = '200'

  ## MySQL
  default[:mysql][:config][:innodb_buffer_pool_size] = '512M'
  default[:mysql][:config][:query_cache_size] = '512M'
  default[:mysql][:config][:tmp_table_size]  = '512M'
  default[:mysql][:config][:max_connections] = '256'
  default[:mysql][:config][:thread_cache] = '256'
when "m3.2xlarge"
  ## Nginx
  default[:nginx][:config][:worker_processes] = '8'

  ## PHP
  default[:php][:config][:max_children] = '35'
  default[:php][:config][:start_servers] = '10'
  default[:php][:config][:min_spare_servers] = '10'
  default[:php][:config][:max_spare_servers] = '25'
  default[:php][:config][:max_requests] = '200'

  ## MySQL
  default[:mysql][:config][:innodb_buffer_pool_size] = '512M'
  default[:mysql][:config][:query_cache_size] = '512M'
  default[:mysql][:config][:tmp_table_size]  = '512M'
  default[:mysql][:config][:max_connections] = '256'
  default[:mysql][:config][:thread_cache] = '256'
when "m1.medium"
  ## Nginx
  default[:nginx][:config][:worker_processes] = '2'

  ## PHP
  default[:php][:config][:max_children] = '20'
  default[:php][:config][:start_servers] = '4'
  default[:php][:config][:min_spare_servers] = '4'
  default[:php][:config][:max_spare_servers] = '16'
  default[:php][:config][:max_requests] = '200'

  ## MySQL
  default[:mysql][:config][:innodb_buffer_pool_size] = '256M'
  default[:mysql][:config][:query_cache_size] = '256M'
  default[:mysql][:config][:tmp_table_size]  = '256M'
  default[:mysql][:config][:max_connections] = '256'
  default[:mysql][:config][:thread_cache] = '256'
when "c1.medium"
  ## Nginx
  default[:nginx][:config][:worker_processes] = '2'

  ## PHP
  default[:php][:config][:max_children] = '20'
  default[:php][:config][:start_servers] = '4'
  default[:php][:config][:min_spare_servers] = '4'
  default[:php][:config][:max_spare_servers] = '16'
  default[:php][:config][:max_requests] = '200'

  ## MySQL
  default[:mysql][:config][:innodb_buffer_pool_size] = '256M'
  default[:mysql][:config][:query_cache_size] = '256M'
  default[:mysql][:config][:tmp_table_size]  = '256M'
  default[:mysql][:config][:max_connections] = '256'
  default[:mysql][:config][:thread_cache] = '256'
when "c1.xlarge"
  ## Nginx
  default[:nginx][:config][:worker_processes] = '8'

  ## PHP
  default[:php][:config][:max_children] = '35'
  default[:php][:config][:start_servers] = '5'
  default[:php][:config][:min_spare_servers] = '5'
  default[:php][:config][:max_spare_servers] = '25'
  default[:php][:config][:max_requests] = '200'

  ## MySQL
  default[:mysql][:config][:innodb_buffer_pool_size] = '256M'
  default[:mysql][:config][:query_cache_size] = '256M'
  default[:mysql][:config][:tmp_table_size]  = '256M'
  default[:mysql][:config][:max_connections] = '256'
  default[:mysql][:config][:thread_cache] = '256'
end
