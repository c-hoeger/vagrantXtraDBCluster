include_recipe 'xtradbcluster::repository'

%w(percona-xtradb-cluster-client-5.5 percona-toolkit sysstat xinetd).each do |pkg|
  package pkg do
    action :install
  end
end
