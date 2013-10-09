## Nginx
default[:nginx][:config][:user] = 'nginx'
default[:nginx][:config][:group] = 'nginx'
default[:nginx][:config][:worker_processes] = '2'

## PHP
default[:php][:config][:user] = 'nginx'
default[:php][:config][:group] = 'nginx'
default[:php][:config][:max_children] = '5'
default[:php][:config][:start_servers] = '1'
default[:php][:config][:min_spare_servers] = '1'
default[:php][:config][:max_spare_servers] = '4'
default[:php][:config][:max_requests] = '200'

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
when "m1.large"
  ## Nginx
  default[:nginx][:config][:worker_processes] = '4'

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
end
