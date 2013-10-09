default[:php][:user] = 'nginx'
default[:php][:group] = 'nginx'

default[:mysql][:user] = 'mysql'

default[:wpcli][:dir] = '/usr/share/wp-cli'
default[:wpcli][:version] = '@stable'
default[:wpcli][:link] = '/usr/bin/wp'
