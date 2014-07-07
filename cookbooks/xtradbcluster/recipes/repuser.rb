if node[:xtradbcluster][:cluster_ip]
  # apt compile_time_update, see https://github.com/opscode-cookbooks/apt/commit/fa3497059afbc6addc15ec2b6eea2d0a74ba77e4
  # node.override[:apt][:compile_time_update] = true
  # include_recipe "database::mysql"

  mysql_connection_info = {:host => "localhost", :username => 'root' } #, :password => node['percona']['root_password']}

  mysql_database_user 'wsrep' do
    connection mysql_connection_info
    host '%'
    password '5ojijmedUg8' #node['percona']['xtrabackup_password']
    privileges ['reload', 'lock tables', 'replication slave', 'replication client']
    action :grant
  end
end
