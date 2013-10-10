require 'serverspec'
require 'pathname'
require 'ohai'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

RSpec.configure do |c|
  if ENV['ASK_SUDO_PASSWORD']
    require 'highline/import'
    c.sudo_password = ask("Enter sudo password: ") { |q| q.echo = false }
  else
    c.sudo_password = ENV['SUDO_PASSWORD']
  end
  c.formatter = :documentation
  ENV['LANG'] = 'C'
end

ohai = Ohai::System.new
ohai.all_plugins
@@ohaidata = ohai.data
