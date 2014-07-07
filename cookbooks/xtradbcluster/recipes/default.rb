
# node.override['mysql']['server_root_password'] = "secret"
# node.override['mysql']['server_debian_password'] = "secret"

# %w{curl rsync libaio1 libnet-daemon-perl libplrpc-perl libdbi-perl}.each do |nPackage|
#   package nPackage do
#     action :install
#   end
# end



include_recipe 'apt'
# include_recipe 'mysql::server'
# include_recipe 'mysql::client'

apt_repository 'percona' do
  uri        'http://repo.percona.com/apt'
  components ['wheezy', 'main' ]
  keyserver "pool.sks-keyservers.net"
  key "CD2EFD2A"
  notifies :run, resources(:execute => "apt-get update"), :immediately
end

package "percona-xtradb-cluster-client-5.5"
package "libmysqlclient-dev"
package "libdbd-mysql-perl"
package "percona-toolkit"
package "sysstat"


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
