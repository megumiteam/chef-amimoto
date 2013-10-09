require 'spec_helper'

describe service('httpd') do
  it { should_not be_enabled }
  it { should_not be_running }
end

%w(nginx php-fpm).each do |service|
  describe service(service) do
    it { should be_enabled }
    it { should be_running }
  end
end

describe command('nginx -t') do
  it { should return_exit_status 0 }
end
