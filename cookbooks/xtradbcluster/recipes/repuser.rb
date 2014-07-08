if node[:xtradbcluster][:cluster_ip]
  repuser = node[:xtradbcluster][:repuser]
  reppw   = node[:xtradbcluster][:reppw]
  raise "need to specify repuser" unless repuser
  raise "need to specify reppw" unless reppw

  # apt compile_time_update, see https://github.com/opscode-cookbooks/apt/commit/fa3497059afbc6addc15ec2b6eea2d0a74ba77e4
  # node.override[:apt][:compile_time_update] = true
  # include_recipe "database::mysql"

  # FIXME: root password
  mysql_connection_info = {:host => "localhost", :username => 'root' } #, :password => node['percona']['root_password']}

  # FIXME: secure data bag
  mysql_database_user repuser do
    connection mysql_connection_info
    host '%'
    password reppw
    privileges ['reload', 'lock tables', 'replication slave', 'replication client']
    action :grant
  end
  mysql_database_user repuser do
    connection mysql_connection_info
    host 'localhost'
    password reppw
    privileges ['reload', 'lock tables', 'replication slave', 'replication client']
    action :grant
  end
end
