require 'spec_helper'

describe service('iptables') do
  it { should_not be_enabled }
  it { should_not be_running }
end
