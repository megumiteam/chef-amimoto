require 'spec_helper'

describe command('wp --version') do
  it { should return_exit_status 0 }
  it { should return_stdout /^WP-CLI/ }
end
