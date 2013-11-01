reload_ohai = false

hints_dir = directory node['ohai']['hints_path'] do
  action :create
  recursive true
  mode '0755' unless platform_family?('windows')
end
hints_dir.run_action(:create)

node['ohai']['hints'].each_pair do |hint_name, data|

  hint_file = file ::File.join(node['ohai']['hints_path'], "#{hint_name}.json") do
    content JSON.pretty_generate(data)
    mode '0644' unless platform_family?('windows')
    action :nothing
  end

  hint_file.run_action(:create)
  reload_ohai ||= hint_file.updated?
end

resource = ohai 'custom_hints' do
  action :nothing
end

if reload_ohai
  resource.run_action(:reload)
end
