
include_recipe 'hostname'
include_recipe 'xtradbcluster::client'
include_recipe 'xtradbcluster::repository'

directory "/etc/mysql" do
  owner "root"
  group "root"
  mode "0755"
  action :create
  not_if { ::File.exists?("/etc/mysql") }
end

template "/etc/mysql/my.cnf" do
  source "my.cnf.erb"
  owner "root"
  group "root"
  mode 0755
end

package "percona-xtradb-cluster-server-5.5"
