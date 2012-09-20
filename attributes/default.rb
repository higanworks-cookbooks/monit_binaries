default[:monit][:version] = "5.4"

case node[:kernel][:machine]
  when "x86_64" then
    default[:monit][:arc] = "x64"
  when "x86" then
    default[:monit][:arc] = "x86"
end

default[:monit][:binaries] = "monit-#{node[:monit][:version]}-#{node[:os]}-#{node[:monit][:arc]}"