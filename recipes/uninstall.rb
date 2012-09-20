#
# Cookbook Name:: monit_src
# Recipe:: uninstall
#
# Copyright 2012, Higanworks LLC.
#

# This recipe was written for repeat testing install.
# Therefore this is unstable. Don't use.


%W{/etc/monit #{Chef::Config[:file_cache_path]}/monit}.each do |w|
  directory w do
    recursive true
    action :delete
  end
end

%w{/usr/sbin/monit /usr/share/man/man1/monit.1}.each do |w|
  file w do
    action :delete
  end
end

execute "mandb" do
  command "mandb"
  action :run
end
