%w(portmap nfs-utils nfs-utils-lib).each do |pkg|
  package pkg do
    action [:install, :upgrade]
  end
end

nginx_uid = `id -u nginx`.chomp
nginx_gid = `id -g nginx`.chomp

file '/etc/exports' do
  content "/var/www/vhosts/#{node[:ec2][:instance_id]} *(rw,async,no_acl,root_squash,all_squash,anonuid=#{nginx_uid},anongid=#{nginx_gid})"
end

%w(rpcbind nfslock nfs).each do |svc|
  service svc do
    action [:enable, :start]
    subscribes :restart, 'file[/etc/exports]'
  end
end

