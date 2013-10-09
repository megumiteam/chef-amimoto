require 'spec_helper'

## Repo Percona

describe yumrepo('percona') do
  it { should exist }
  it { should be_enabled }
end

describe command('mysqladmin ping') do
  it { should return_exit_status 0 }
end

describe command('mysqld -V') do
  it { should return_stdout /Percona\ Server/ }
end
