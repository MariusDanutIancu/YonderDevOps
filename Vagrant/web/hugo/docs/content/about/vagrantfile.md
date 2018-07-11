---
title: "Vagrant file"
date: 2018-01-28T21:48:10+01:00
anchor: "vagrant_file"
weight: 12
---

```ruby
Vagrant.configure("2") do |config|
	
	# variables
	os = "centos/7"
	net = "10.143.20"
  	
	# default provider
	config.vm.provider "libvirt"  

	config.vm.define :proxy do |proxy_config| 
    		
		proxy_config.vm.host_name = 'proxy'
        proxy_config.vm.box = "#{os}"		
        proxy_config.vm.network :private_network, :ip =>'10.143.20.2'

		proxy_config.vm.provider :libvirt do |lv|
			lv.memory = 1024
        	lv.cpus = 1
			lv.driver = "kvm"
        	lv.username = "root"
			lv.password = "root"
    	end
		
		proxy_config.vm.provision "file", source: "nginx/nginx.conf", destination: "/home/vagrant/files/nginx.conf"
		proxy_config.vm.provision "file", source: "nginx/yonder_devops.com.conf", destination: "/home/vagrant/files/yonder_devops.com.conf"

		proxy_config.vm.provision "shell", path: "provision_scripts/proxy.sh"

  	end

	config.vm.define :web do |web_config| 
    		
		web_config.vm.host_name = 'web'
        web_config.vm.box = "#{os}"		
		web_config.vm.network :private_network, :ip =>'10.143.20.3'

		web_config.vm.provider :libvirt do |lv|
			lv.memory = 1024
            lv.cpus = 1
			lv.driver = "kvm"
        	lv.username = "root"
			lv.password = "root"
    	end
	
		web_config.vm.provision "file", source: "go-intern/go-intern.conf", destination: "/home/vagrant/files/go-intern.conf"
  		web_config.vm.provision "file", source: "go-intern/go-intern.service", destination: "/home/vagrant/files/go-intern.service"
  		web_config.vm.provision "file", source: "go-intern/go-intern.spec", destination: "/home/vagrant/files/go-intern.spec"
  		web_config.vm.provision "file", source: "go-intern/conf.json", destination: "/home/vagrant/files/conf.json"

  		web_config.vm.provision "shell", path: "provision_scripts/web.sh"

  	end
	
	config.vm.define :db do |db_config| 
    		
		db_config.vm.host_name = 'db'
        db_config.vm.box = "#{os}"		
		db_config.vm.network :private_network, :ip =>'10.143.20.4'

		db_config.vm.provider :libvirt do |lv|
			lv.memory = 1024
        	lv.cpus = 1
			lv.driver = "kvm"
        	lv.username = "root"
			lv.password = "root"
    	end
		
		db_config.vm.provision "file", source: "database/database_script.sh", destination: "/home/vagrant/files/database_script.sh"

		db_config.vm.provision "shell", path: "provision_scripts/db.sh"
  
  	end

	config.vm.define :monitor do |monitor_config| 
    		
		monitor_config.vm.host_name = 'monitor'
        monitor_config.vm.box = "#{os}"		
		monitor_config.vm.network :private_network, :ip =>'10.143.20.5'

		monitor_config.vm.provider :libvirt do |lv|
			lv.memory = 1024
        	lv.cpus = 1
			lv.driver = "kvm"
        	lv.username = "root"
			lv.password = "root"
    	end

		monitor_config.vm.provision "shell", path: "provision_scripts/monitor.sh"
  
  	end

end
```


