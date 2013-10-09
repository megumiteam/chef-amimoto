### For debug


class Chef::Handler::LogReport < ::Chef::Handler
  def report
    Chef::Log.warn '======= All Resources are following...'
    data[:all_resources].each.with_index do |r,idx|
      Chef::Log.warn [idx, r.to_s].join(':')
    end
    Chef::Log.warn '======= Update Resources are following...'
    data[:updated_resources].each.with_index do |r,idx|
      Chef::Log.warn [idx, r.to_s].join(':')
    end
  end
end

Chef::Config[:report_handlers] << Chef::Handler::LogReport.new
Chef::Config[:report_handlers] << Chef::Handler::JsonFile.new
