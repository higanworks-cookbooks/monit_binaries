#
# Cookbook Name:: monit_binaries
# Recipe:: default
#
# Copyright 2012, Higanworks LLC.
#


%w{/etc/monit /etc/monit/conf.enable /etc/monit/conf.avail /usr/local/src/monit}.each do |w|
  directory w do
    action :create
    owner "root"
    group "root"
    mode  "0700"
  end
end


script "install_from_source" do
  interpreter "bash"
  user "root"
  Chef::Log.info("Start: install monit-#{node[:monit][:version]}")
  flags "-e"
  code <<-"EOH"
    mkdir -p #{Chef::Config[:file_cache_path]}/monit
    cd #{Chef::Config[:file_cache_path]}
    wget http://mmonit.com/monit/dist/binary/#{node[:monit][:version]}/#{node[:monit][:binaries]}.tar.gz
    tar xvzf #{node["monit"][:binaries]}.tar.gz
    cp -f monit-#{node[:monit][:version]}/bin/monit /usr/sbin/
    cp -f monit-#{node[:monit][:version]}/man/man1/monit.1 /usr/share/man/man1
    mandb
  EOH

  only_if "test ! -f #{Chef::Config[:file_cache_path]}/monit/#{node[:monit][:binaries]}.tar.gz"
  Chef::Log.info("End: install monit-#{node[:monit][:version]}")
end
