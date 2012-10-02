# cookbook Name:: monit_binaries
# Definition:: monit_site
# Author:: Yukihiko Sawanobori <sawanoboriyu@higanorks.com>
#
# Refernce: Opscode-cookbook::nginx
# Copyright 2011-2012, HiganWorks LLC
#

define :monit_setting, :enable => true do
  if params[:enable]
    execute "monitensite #{params[:name]}" do
      command "/usr/local/sbin/monitensite #{params[:name]}"
      notifies :reload, resources(:service => "imonit")
      not_if do ::File.symlink?("#{node['monit']['dir']}/monit.enable/#{params[:name]}.conf") end
    end
  else
    execute "monitdisite #{params[:name]}" do
      command "/usr/local/sbin/monitdisite #{params[:name]}"
      notifies :reload, resources(:service => "monit")
      only_if do ::File.symlink?("#{node['monit']['dir']}/monit.enable/#{params[:name]}.conf") end
    end
  end
end
