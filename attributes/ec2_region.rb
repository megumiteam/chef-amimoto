tztable = {
  "eu-west-1" => "WET",
  "sa-east-1" => "America/Sao_Paulo",
  "us-east-1" => "US/Eastern",
  "ap-northeast-1" => "Asia/Tokyo",
  "us-west-2" => "US/Pacific",
  "us-west-1" => "US/Pacific",
  "ap-southeast-1" => "Asia/Singapore"
}


default[:ec2][:region] = "ap-northeast-1"
default[:timezone] = "Asia/Tokyo"

