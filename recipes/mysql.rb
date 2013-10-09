# configure mysql
service "mysql" do
  action [:enable, :start]
end

## check innodb_log_file_size
node.run_state[:mysql_flush_ib_logfiles] = false
current_innodb_log_file_size =  get_mysql_variable("innodb_log_file_size")
new_innodb_log_file_size =  to_mysql_bytes(node[:mysql][:config][:innodb_log_file_size])

unless current_innodb_log_file_size == new_innodb_log_file_size
  node.run_state[:mysql_flush_ib_logfiles] = true
end

template "/etc/my.cnf" do
  variables node[:mysql][:config]
  source "my.cnf.erb"
  notifies :reload, 'service[mysql]' unless node.run_state[:mysql_flush_ib_logfiles]
end

## restart with flush innodb_log_files

if node.run_state[:mysql_flush_ib_logfiles]
  restart_mysql_with_flush_ib_logfiles
end

node.run_state.delete(:mysql_flush_ib_logfiles)
