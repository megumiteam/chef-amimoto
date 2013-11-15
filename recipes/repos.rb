if %w(redhat).include?(node[:platform])
  template '/etc/yum.repos.d/nginx.repo' do
    source 'yum/nginx.repo.erb'
    action :create
  end

  template '/etc/yum.repos.d/rpmforge.repo' do
    source 'yum/rpmforge.repo.erb'
    action :create
  end

  template '/etc/yum.repos.d/epel.repo' do
    source 'yum/epel.repo.erb'
    action :create
  end

  %w(libmcrypt).each do |pkg|
    yum_package pkg do
      action [:install, :upgrade]
      options '--enablerepo=epel'
      flush_cache [:before]
    end
  end

  template '/etc/yum.repos.d/iuscommunity.repo' do
    source 'yum/iuscommunity.repo.erb'
    action :create
  end
end
