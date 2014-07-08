
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

directory "/etc/mysql/conf.d" do
  owner "root"
  group "root"
  mode "0755"
  action :create
  not_if { ::File.exists?("/etc/mysql/conf.d") }
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

case node['platform_family']
when 'rhel'
  cserver = "Percona-XtraDB-Cluster-server-55"
when 'debian'
  cserver = "percona-xtradb-cluster-server-5.5"
else
  raise "unsupported platform family " + node['platform_family']
end

package cserver do
  action :install
end

if platform_family?("rhel")
  service "mysql" do
    supports :restart => true, :reload => true
    action [ :enable, :start ]
    subscribes :start, "package[#{cserver}]", :immediately
  end
end

service "xinetd" do
  supports :restart => true, :reload => true
  action [ :enable, :start ]
end
