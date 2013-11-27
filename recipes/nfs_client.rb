%w(portmap nfs-utils nfs-utils-lib).each do |pkg|
  package pkg do
    action [:install, :upgrade]
  end
end

cfn = JSON.load(::File.read('/opt/aws/cloud_formation.json'))
describe_cmd = "aws ec2 describe-instances --instance-id #{cfn['nfs']['server']['instance-id']} --region #{node.ec2[:placement_availability_zone].chop} "
masterserver = JSON.load(`#{describe_cmd}`)
master_ip = masterserver['Reservations'].first['Instances'].first["PrivateIpAddress"]

mount "/var/www/vhosts/#{node[:ec2][:instance_id]}" do
  action [:mount, :enable]
  device "#{master_ip}:/var/www/vhosts/#{cfn['nfs']['server']['instance-id']}"
  fstype "nfs"
  options "rw"
end

