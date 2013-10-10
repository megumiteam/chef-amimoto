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
  },
  {
   :name => 'php-fpm',
   :pidfile => '/var/run/php-fpm/php-fpm.pid',
   :start => '/sbin/service php-fpm start',
   :stop  => '/sbin/service php-fpm stop',
   :rules => [
   ]
  },
  {
   :name => 'mysql',
   :pidfile => '/var/run/mysqld/mysqld.pid',
   :start => '/sbin/service mysql start',
   :stop  => '/sbin/service mysql stop',
   :rules => [
   ]
  },
  {
   :name => 'crond',
   :pidfile => '/var/run/crond.pid',
   :start => '/sbin/service crond start',
   :stop  => '/sbin/service crond stop',
   :rules => [
   ]
  },
]
