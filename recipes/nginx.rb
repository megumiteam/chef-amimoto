# nginx install

service "httpd" do
  action [:stop, :disable]
end
node[:nginx][:packages].each do | pkg |
  package pkg do
    action [:install, :upgrade]
  end
end

# configure nginx

template "/etc/nginx/nginx.conf" do
  variables node[:nginx][:config]
  source "nginx/nginx.conf.erb"
  notifies :reload, 'service[nginx]'
end

%w{ drop expires mobile-detect phpmyadmin php-fpm wp-multisite-subdir wp-singlesite }.each do | file_name |
  template "/etc/nginx/" + file_name do
    variables node[:nginx][:config]
    source "nginx/" + file_name + ".erb"
    notifies :reload, 'service[nginx]'
  end
end

%w{ default.conf default.backend.conf }.each do | file_name |
  template "/etc/nginx/conf.d/" + file_name do
    variables(
      :server_name => node[:ec2][:instance_id],
      :phpmyadmin_enable => node[:nginx][:config][:phpmyadmin_enable]
    )
    source "nginx/conf.d/" + file_name + ".erb"
    notifies :reload, 'service[nginx]'
  end
end

%W{ /var/cache/nginx /var/log/nginx /var/lib/nginx /var/tmp/nginx /opt/local/amimoto /opt/local/amimoto/wp-admin /var/www/vhosts/#{node[:ec2][:instance_id]} }.each do | dir_name |
  directory dir_name do
    owner node[:nginx][:config][:user]
    group node[:nginx][:config][:group]
    mode 00755
    recursive true
    action :create
  end
end

template "/opt/local/amimoto/wp-admin/install.php" do
  variables(
    :instance_id => node[:ec2][:instance_id]
  )
  source "install.php.erb"
end

service "nginx" do
  action node[:nginx][:service_action]
end
