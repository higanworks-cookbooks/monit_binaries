default['monit']['version'] = "5.5"

case node['kernel']['machine']
  when "x86_64" then
    default['monit']['arc'] = "x64"
  when "i686" then
    default['monit']['arc'] = "x86"
end

default['monit']['binaries'] = "monit-#{node['monit']['version']}-#{node['os']}-#{node['monit']['arc']}"

default['monit']['dir'] = '/etc/monit'

