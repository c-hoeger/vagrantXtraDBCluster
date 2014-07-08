include_recipe 'xtradbcluster::repository'

case node['platform_family']
when 'rhel'
  cclient = "Percona-XtraDB-Cluster-client-55"
when 'debian'
  cclient = "percona-xtradb-cluster-client-5.5"
else
  raise "unsupported platform family " + node['platform_family']
end

if platform_family?("rhel")
  package "mysql" do
    action :remove
  end
end

package cclient do
  action :install
end

%w(percona-toolkit sysstat xinetd).each do |pkg|
  package pkg do
    action :install
  end
end
