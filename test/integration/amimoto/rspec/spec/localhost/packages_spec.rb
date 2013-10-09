require 'spec_helper'

%w{ memcached zip unzip wget iptables git }.each do | pkg |
  describe package(pkg) do
    it { should be_installed }
  end
end

