
pversion = node["platform_version"].to_i
debmaps = { 6 => "squeeze", 7 => "wheezy" }

if platform_family?("debian")
  include_recipe 'apt'

  # haproxy
  apt_repository 'backports' do
    uri        'http://http.debian.net/debian'
    components [debmaps[pversion] + '-backports', 'main' ]
  end

  apt_repository 'percona' do
    uri        'http://repo.percona.com/apt'
    components [debmaps[pversion], 'main' ]
    keyserver "pool.sks-keyservers.net"
    key "CD2EFD2A"
    notifies :run, resources(:execute => "apt-get update"), :immediately
  end
elsif platform_family?("rhel")
    include_recipe 'yum'
    include_recipe 'yum-epel'

		yum_repository "percona" do
      baseurl 			"http://repo.percona.com/centos/$releasever/os/$basearch/"
			gpgkey 			 "http://www.percona.com/downloads/RPM-GPG-KEY-percona"
			action :create
		end
else
  raise "unsupported platform family " + node["platform_family"]
end
