package 'monit' do
  action [:install, :upgrade]
end

service 'monit' do
  action [:enable, :start]
  reload_command 'monit reload'
end

template node[:monit][:config_file] do
  source 'monit/monit.conf.erb'
  variables node[:monit][:config]
  notifies :restart, 'service[monit]'
  mode '0600'
end

node[:monit][:settings][:processes].each do |monit|
  template ::File.join(node[:monit][:config_dir], monit[:name]) do
    source 'monit/process_monitor.erb'
    variables monit
    notifies :reload, 'service[monit]'
  end
end
