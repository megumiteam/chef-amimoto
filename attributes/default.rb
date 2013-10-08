default[:nginx][:user] = 'nginx'
default[:nginx][:group] = 'nginx'

default[:php][:user] = 'nginx'
default[:php][:group] = 'nginx'

default[:mysql][:user] = 'mysql'

default[:wp-cli][:wpcli-dir] = '/usr/share/wp-cli'
default[:wp-cli][:wpcli-version] = '@stable'
default[:wp-cli][:wpcli-link] = '/usr/bin/wp'
