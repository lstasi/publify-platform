Vagrant.configure(2) do |config|
  
  config.vm.provision "shell", path: "provision/install_puppet.sh"
  
  config.vm.provision "puppet" do |puppet|
	puppet.options = "--verbose"
    puppet.module_path = "modules"
	end
  config.vm.provider "virtualbox" do |v|
		v.memory = 1024
		v.cpus = 2
	end
	
	config.vm.define "lb" do |lb|
		lb.vm.box = "puppetlabs/centos-7.0-64-puppet"
		lb.vm.hostname = "lb"
		lb.vm.network "private_network", ip: "192.168.56.2"
		end
    config.vm.define "db" do |db|
	    db.vm.box = "puppetlabs/centos-7.0-64-puppet"
		db.vm.hostname = "db"
		db.vm.network "private_network", ip: "192.168.56.20"
		end
	config.vm.define "web" do |web|
		web.vm.box = "puppetlabs/centos-7.0-64-puppet"
		web.vm.hostname = "web"
		web.vm.network "private_network", ip: "192.168.56.10"
	end
end