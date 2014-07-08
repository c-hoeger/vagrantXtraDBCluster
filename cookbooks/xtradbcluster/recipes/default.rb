
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

directory "/etc/xinetd.d" do
  owner "root"
  group "root"
  mode "0755"
  action :create
  not_if { ::File.exists?("/etc/xinetd.d") }
end

template "/etc/xinetd.d/mysqlchkvagrant" do
  source "xinetd.conf.erb"
  owner "root"
  group "root"
  mode 0750
  notifies :restart, "service[xinetd]", :delayed
end

package "percona-xtradb-cluster-server-5.5" do
  action :install
end

service "xinetd" do
  supports :restart => true, :reload => true
  action [ :enable, :start ]
end
