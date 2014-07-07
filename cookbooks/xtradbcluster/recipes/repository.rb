include_recipe 'apt'

apt_repository 'percona' do
  uri        'http://repo.percona.com/apt'
  components ['wheezy', 'main' ]
  keyserver "pool.sks-keyservers.net"
  key "CD2EFD2A"
  notifies :run, resources(:execute => "apt-get update"), :immediately
end
