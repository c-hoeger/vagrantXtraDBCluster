Vagrant.configure("2") do |config|

  proxyurl = "http://" + IPSocket.getaddress(Socket.gethostname) + ":8123"
  boxname  = "opscode-debian-7.4-chef"

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

    vm_config.vm.network "private_network", ip: "10.0.3.40"
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
    end

  end


  config.vm.define :node1 do |vm_config|
    vm_config.vm.box = boxname
    #vm_config.vm.box_url = "https://s3-eu-west-1.amazonaws.com/rosstimson-vagrant-boxes/debian-squeeze-64-rvm.box"

    vm_config.vm.network "private_network", ip: "10.0.3.10"
    vm_config.vm.network "forwarded_port", guest: 22, host: 2205

    vm_config.vm.provider "virtualbox" do |v|
      v.customize ["modifyvm", :id, "--memory", "512"]
      v.customize ["modifyvm", :id, "--name", "node1"]
    end

    vm_config.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = "cookbooks"
#      chef.add_recipe("xtradbcluster::checks")
      chef.add_recipe("xtradbcluster")

      chef.json.merge!( :xtradbcluster => { :cluster_ip => "", :name => "node1", :recv_ip => "10.0.3.10" })
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
