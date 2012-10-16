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

include_recipe "monit_binaries::include"
# service "monit" do
#   provider Chef::Provider::Service::Upstart
# end

%w{/etc/monit /var/monit /etc/monit/conf.enable /etc/monit/conf.avail /usr/local/src/monit}.each do |w|
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
  Chef::Log.info("Start: install monit-#{node['monit']['version']}")
  flags "-e"
  code <<-"EOH"
    mkdir -p #{Chef::Config[:file_cache_path]}/monit
    cd #{Chef::Config[:file_cache_path]}/monit
    wget http://mmonit.com/monit/dist/binary/#{node['monit']['version']}/#{node['monit']['binaries']}.tar.gz
    tar xvzf #{node["monit"]['binaries']}.tar.gz
    cp -f monit-#{node['monit']['version']}/bin/monit /usr/sbin/
    cp -f monit-#{node['monit']['version']}/man/man1/monit.1 /usr/share/man/man1
    mandb
  EOH

  only_if "test ! -f #{Chef::Config[:file_cache_path]}/monit/#{node['monit']['binaries']}.tar.gz"
  Chef::Log.info("End: install monit-#{node['monit']['version']}")
  notifies :restart, "service[monit]"
end


# monit setting controler

directory "/usr/local/sbin" do
  mode 00755
  owner "root"
  group "root"
end

%w(monitensite monitdisite).each do |command|
  template "/usr/local/sbin/#{command}" do
    source "#{command}.erb"
    mode 0744
    owner "root"
    group "root"
  end
end

