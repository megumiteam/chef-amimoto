# configure php

%w{ php.ini php-fpm.conf php.d/apc.ini php.d/memcache.ini }.each do | file_name |
  template "/etc/" + file_name do
    source "php/" + file_name + ".erb"
    notifies :reload, 'service[php-fpm]'
  end
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
