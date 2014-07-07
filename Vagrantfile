Vagrant.configure("2") do |config|

  # some global settings
  proxyurl = "http://" + IPSocket.getaddress(Socket.gethostname) + ":8123"
  boxname  = "opscode-debian-7.4-chef"
  domain   = "example.com"
  repuser  = "wsrep"
  reppw    = "GnAnAnANA"
  sstauth  = "wsrep:5ojijmedUg8"
  haproxip = "10.0.3.40"
  node1ip  = "10.0.3.10"
  node2ip  = "10.0.3.20"
  node3ip  = ""

  config.berkshelf.enabled = true

  if proxyurl
    config.proxy.http      = proxyurl
    config.proxy.https     = proxyurl
    config.proxy.no_proxy  = "localhost"
    config.apt_proxy.http  = proxyurl
    config.apt_proxy.https = proxyurl
    config.yum_proxy.http  = proxyurl
  end

  config.vm.define :haproxy do |vm_config|
    vm_config.vm.box = boxname
    #vm_config.vm.box_url = "https://s3-eu-west-1.amazonaws.com/rosstimson-vagrant-boxes/debian-squeeze-64-rvm.box"

    vm_config.vm.network "private_network", ip: haproxip
    vm_config.vm.network "forwarded_port", guest: 22, host: 2208
    vm_config.vm.network "forwarded_port", guest: 80, host: 8080
    vm_config.vm.network "forwarded_port", guest: 3306, host: 3306

    vm_config.vm.provider "virtualbox" do |v|
      v.customize ["modifyvm", :id, "--memory", "256"]
      v.customize ["modifyvm", :id, "--name", "haproxy"]
    end


    vm_config.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = "cookbooks"
      chef.add_recipe("xtradbcluster::haproxy")
      chef.json.merge!( :set_fqdn => "haproxy.#{domain}",
                        :hostname_cookbook => { :hostsfile_ip => haproxip } )
    end

  end


  config.vm.define :node1 do |vm_config|
    vm_config.vm.box = boxname
    #vm_config.vm.box_url = "https://s3-eu-west-1.amazonaws.com/rosstimson-vagrant-boxes/debian-squeeze-64-rvm.box"

    vm_config.vm.network "private_network", ip: node1ip
    vm_config.vm.network "forwarded_port", guest: 22, host: 2205

    vm_config.vm.provider "virtualbox" do |v|
      v.customize ["modifyvm", :id, "--memory", "512"]
      v.customize ["modifyvm", :id, "--name", "node1"]
    end

    vm_config.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = "cookbooks"
#      chef.add_recipe("xtradbcluster::checks")
      # ONLY works when executed here in the runlist
      chef.add_recipe("database::mysql")
      chef.add_recipe("xtradbcluster")
      # create the replication user (only on 1st node)
      chef.add_recipe("xtradbcluster::repuser")
      # apt compile_time_update, see https://github.com/opscode-cookbooks/apt/commit/fa3497059afbc6addc15ec2b6eea2d0a74ba77e4
      chef.json.merge!( :xtradbcluster => { :cluster_ip => "", :name => "node1", :recv_ip => node1ip, :bind_address => node1ip },
                        :set_fqdn => "node1.#{domain}",
                        :apt => { :compile_time_update => true },
                        :hostname_cookbook => { :hostsfile_ip => node1ip })
    end


  end

  config.vm.define :node2 do |vm_config|
    vm_config.vm.box = boxname
    #vm_config.vm.box_url = "https://s3-eu-west-1.amazonaws.com/rosstimson-vagrant-boxes/debian-squeeze-64-rvm.box"

    vm_config.vm.network "private_network", ip: node2ip
    vm_config.vm.network "forwarded_port", guest: 22, host: 2206

    vm_config.vm.provider "virtualbox" do |v|
      v.customize ["modifyvm", :id, "--memory", "512"]
      v.customize ["modifyvm", :id, "--name", "node2"]
    end

    vm_config.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = "cookbooks"
      # chef.add_recipe("xtradbcluster::checks")
      chef.add_recipe("xtradbcluster")

      chef.json.merge!( :xtradbcluster => { :cluster_ip => node1ip, :name => "node2", :recv_ip => node2ip, :bind_address => node2ip, :sst_auth => sstauth },
                        :set_fqdn => "node2.#{domain}",
                        :hostname_cookbook => { :hostsfile_ip => node2ip })
    end


  end

  #
  # config.vm.define :node2 do |vm_config|
  #   vm_config.vm.box = "opscode-debian-7.4-chef"
  #   #vm_config.vm.box_url = "https://s3-eu-west-1.amazonaws.com/rosstimson-vagrant-boxes/debian-squeeze-64-rvm.box"
  #
  # vm_config.vm.network :hostonly, "10.0.3.20"
  #
  #   vm_config.vm.customize ["modifyvm", :id, "--memory", "512"]
  #   vm_config.vm.customize ["modifyvm", :id, "--name", "node2"]
  #
  #   vm_config.vm.forward_port 22, 2206
  #
  #   vm_config.vm.provision :chef_solo do |chef|
  #     chef.cookbooks_path = "cookbooks"
  #     chef.add_recipe("xtradbcluster::checks")
  #     chef.add_recipe("xtradbcluster")
  #
  #     chef.json.merge!( :xtradbcluster => { :cluster_ip => "10.0.3.10", :name => "node2", :recv_ip => "10.0.3.20" })
  #   end
  #
  # end
  #
  # config.vm.define :node3 do |vm_config|
  #   vm_config.vm.box = "opscode-debian-7.4-chef"
  #   #vm_config.vm.box_url = "https://s3-eu-west-1.amazonaws.com/rosstimson-vagrant-boxes/debian-squeeze-64-rvm.box"
  #
  # vm_config.vm.network :hostonly, "10.0.3.30"
  #
  #   vm_config.vm.customize ["modifyvm", :id, "--memory", "512"]
  #   vm_config.vm.customize ["modifyvm", :id, "--name", "node3"]
  #
  #   vm_config.vm.forward_port 22, 2207
  #
  #   vm_config.vm.provision :chef_solo do |chef|
  #     chef.cookbooks_path = "cookbooks"
  #     chef.add_recipe("xtradbcluster::checks")
  #     chef.add_recipe("xtradbcluster")
  #
  #     chef.json.merge!( :xtradbcluster => { :cluster_ip => "10.0.3.10", :name => "node3", :recv_ip => "10.0.3.30" })
  #   end
  #
  # end



end
