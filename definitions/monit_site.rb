# cookbook Name:: monit_binaries
# Definition:: monit_site
# Author:: Yukihiko Sawanobori <sawanoboriyu@higanorks.com>
#
# Refernce: Opscode-cookbook::nginx
# Copyright 2011-2012, HiganWorks LLC
#

define :monit_site, :enable => true do
  if params[:enable]
    execute "monitensite #{params[:name]}" do
      command "ln -s /etc/monit/conf.avail/#{params[:name]}.conf /etc/monit/conf.enable/#{params[:name]}.conf"
      notifies :reload, resources(:service => "monit")
      not_if do ::File.symlink?("/etc/monit/conf.enable/#{params[:name]}.conf") end
    end
  else
    execute "monitdisite #{params[:name]}" do
      command "rm /etc/monit/conf.enable/#{params[:name]}.conf"
      notifies :reload, resources(:service => "monit")
      only_if do ::File.symlink?("/etc/monit/conf.enable/#{params[:name]}.conf") end
    end
  end
end

