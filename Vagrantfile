Vagrant.configure("2") do |config|

  #
  # some global settings
  #
  # optional: if you want to use a proxy like polipo (http://www.pps.univ-paris-diderot.fr/~jch/software/polipo/)
  # uncomment the setting below and either specify the url like http://192.168.1.1:8123
  # or use the statement below
  # proxyurl = "http://" + IPSocket.getaddress(Socket.gethostname) + ":8123"
  # name of the image
  boxname  = "opscode-debian-7.4-chef"
  # boxurl   = "http://url-to-image"
  # domain to use
  domain   = "example.com"
  # username password for replication
  repuser  = "wsrep"
  reppw    = "GnAnAnANA"
  # ip addresses of systems
  haproxip = "10.0.3.40"
  node1ip  = "10.0.3.10"
  node2ip  = "10.0.3.20"
  node3ip  = "10.0.3.30"
  #
  # end of settings
  #

  config.berkshelf.enabled = true

  if defined? proxyurl
    config.proxy.http      = proxyurl
    config.proxy.https     = proxyurl
    config.proxy.no_proxy  = "localhost"
    config.apt_proxy.http  = proxyurl
    config.apt_proxy.https = proxyurl
    config.yum_proxy.http  = proxyurl
  end

  if defined? repuser && defined? reppw
    sstauth  = "#{repuser}:#{reppw}"
  else
    sstauth = ""
  end

  config.vm.define :haproxy do |vm_config|
    vm_config.vm.box = boxname
    if defined? boxurl
      vm_config.vm.box_url = boxurl
    end

    vm_config.vm.network "private_network", ip: haproxip
    # vm_config.vm.network "forwarded_port", guest: 22, host: 2208
    vm_config.vm.network "forwarded_port", guest: 80, host: 8080
    vm_config.vm.network "forwarded_port", guest: 3306, host: 3306

    vm_config.vm.provider "virtualbox" do |v|
      v.customize ["modifyvm", :id, "--memory", "256"]
      v.customize ["modifyvm", :id, "--name", "haproxy"]
    end


    vm_config.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = "cookbooks"
      chef.add_recipe("xtradbcluster::haproxy")
      chef.json.merge!( :xtradbcluster => { :dbnode1_ip => node1ip, :dbnode2_ip => node2ip, :dbnode3_ip => node3ip },
                        :set_fqdn => "haproxy.#{domain}",
                        :hostname_cookbook => { :hostsfile_ip => haproxip } )
    end
  end


  config.vm.define :node1 do |vm_config|
    vm_config.vm.box = boxname
    if defined? boxurl
      vm_config.vm.box_url = boxurl
    end

    vm_config.vm.network "private_network", ip: node1ip
    # vm_config.vm.network "forwarded_port", guest: 22, host: 2205

    vm_config.vm.provider "virtualbox" do |v|
      v.customize ["modifyvm", :id, "--memory", "512"]
      v.customize ["modifyvm", :id, "--name", "node1"]
    end

    vm_config.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = "cookbooks"
      # ONLY works when executed here in the runlist
      chef.add_recipe("database::mysql")
      chef.add_recipe("xtradbcluster")
      chef.add_recipe("xtradbcluster::repuser")
      # apt compile_time_update, see https://github.com/opscode-cookbooks/apt/commit/fa3497059afbc6addc15ec2b6eea2d0a74ba77e4
      chef.json.merge!( :xtradbcluster => { :cluster_ip => "", :name => "node1", :recv_ip => node1ip, :bind_address => node1ip,
                                            :repuser => repuser, :reppw => reppw },
                        :set_fqdn => "node1.#{domain}",
                        :apt => { :compile_time_update => true },
                        :hostname_cookbook => { :hostsfile_ip => node1ip })
    end
  end

  config.vm.define :node2 do |vm_config|
    vm_config.vm.box = boxname
    if defined? boxurl
      vm_config.vm.box_url = boxurl
    end

    vm_config.vm.network "private_network", ip: node2ip
    # vm_config.vm.network "forwarded_port", guest: 22, host: 2206

    vm_config.vm.provider "virtualbox" do |v|
      v.customize ["modifyvm", :id, "--memory", "512"]
      v.customize ["modifyvm", :id, "--name", "node2"]
    end

    vm_config.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = "cookbooks"
      chef.add_recipe("database::mysql")
      chef.add_recipe("xtradbcluster")
      chef.add_recipe("xtradbcluster::repuser")

      chef.json.merge!( :xtradbcluster => { :cluster_ip => node1ip, :name => "node2", :recv_ip => node2ip, :bind_address => node2ip,
                                            :sst_auth => sstauth, :repuser => repuser, :reppw => reppw },
                        :set_fqdn => "node2.#{domain}",
                        :apt => { :compile_time_update => true },
                        :hostname_cookbook => { :hostsfile_ip => node2ip })
    end
  end

  config.vm.define :node3 do |vm_config|
    vm_config.vm.box = boxname
    if defined? boxurl
      vm_config.vm.box_url = boxurl
    end

    vm_config.vm.network "private_network", ip: node3ip
    # vm_config.vm.network "forwarded_port", guest: 22, host: 2207

    vm_config.vm.provider "virtualbox" do |v|
      v.customize ["modifyvm", :id, "--memory", "512"]
      v.customize ["modifyvm", :id, "--name", "node3"]
    end

    vm_config.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = "cookbooks"
      chef.add_recipe("database::mysql")
      chef.add_recipe("xtradbcluster")
      chef.add_recipe("xtradbcluster::repuser")

      chef.json.merge!( :xtradbcluster => { :cluster_ip => node1ip, :name => "node3", :recv_ip => node3ip, :bind_address => node3ip,
                                            :sst_auth => sstauth, :repuser => repuser, :reppw => reppw },
                        :set_fqdn => "node3.#{domain}",
                        :apt => { :compile_time_update => true },
                        :hostname_cookbook => { :hostsfile_ip => node3ip })
    end
  end

end
