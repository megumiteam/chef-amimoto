## Nginx
default[:nginx][:config][:user] = 'nginx'
default[:nginx][:config][:group] = 'nginx'
default[:nginx][:config][:worker_processes] = "2"

## PHP

## MySQL

case node[:ec2][:instance_type]
when "t1.micro"
	default[:nginx][:config][:worker_processes] = "2"
when "m1.large"
	default[:nginx][:config][:worker_processes] = "4"
end
