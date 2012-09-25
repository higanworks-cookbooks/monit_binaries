#
# Cookbook Name:: monit_binaries
# Recipe:: default
#
# Copyright 2012, Higanworks LLC.
#

cookbook_file "/etc/init/monit.conf" do
  source "monit_upstart"
  notifies :restart, "service[monit]"
end

service "monit" do
  provider Chef::Provider::Service::Upstart
  supports :restart => true, :reload => true
#  action [:enable, :start ]
  action :nothing
#  only_if File.exists?("/usr/sbin/monit")
end

%w{/etc/monit /etc/monit/conf.enable /etc/monit/conf.avail /usr/local/src/monit}.each do |w|
  directory w do
    action :create
    owner "root"
    group "root"
    mode  "0700"
  end
end


template "/etc/monitrc" do
  source "monitrc.erb"
  notifies :restart, "service[monit]"
end


script "install_from_source" do
  interpreter "bash"
  user "root"
  Chef::Log.info("Start: install monit-#{node[:monit][:version]}")
  flags "-e"
  code <<-"EOH"
    mkdir -p #{Chef::Config[:file_cache_path]}/monit
    cd #{Chef::Config[:file_cache_path]}/monit
    wget http://mmonit.com/monit/dist/binary/#{node[:monit][:version]}/#{node[:monit][:binaries]}.tar.gz
    tar xvzf #{node["monit"][:binaries]}.tar.gz
    cp -f monit-#{node[:monit][:version]}/bin/monit /usr/sbin/
    cp -f monit-#{node[:monit][:version]}/man/man1/monit.1 /usr/share/man/man1
    mandb
  EOH

  only_if "test ! -f #{Chef::Config[:file_cache_path]}/monit/#{node[:monit][:binaries]}.tar.gz"
  Chef::Log.info("End: install monit-#{node[:monit][:version]}")
  notifies :restart, "service[monit]"
end
