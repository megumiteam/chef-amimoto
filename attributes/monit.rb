default[:monit][:config_file]    = '/etc/monit.conf'
default[:monit][:config_dir]     = '/etc/monit.d'
default[:monit][:config][:alert] = []

default[:monit][:settings][:processes] = [
  {
   :name => 'nginx',
   :pidfile => '/var/run/nginx.pid',
   :start => '/sbin/service nginx start',
   :stop  => '/sbin/service nginx stop',
   :rules => [
     'if failed port 80 then restart'
   ]
  }
]
