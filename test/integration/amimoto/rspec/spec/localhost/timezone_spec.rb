require 'spec_helper'

describe command('date +%Z') do
  it { should return_stdout 'JST' }
end
