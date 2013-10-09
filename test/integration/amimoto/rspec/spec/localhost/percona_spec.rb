require 'spec_helper'

## Repo Percona

describe file('/etc/yum.repos.d/Percona.repo') do
  it { should be_file }
end

describe command('mysqladmin ping') do
  it { should return_exit_status 0 }
end

describe command('mysqld -V') do
  it { should return_stdout /Percona\ Server/ }
end
