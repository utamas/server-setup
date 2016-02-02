# -*- mode: ruby -*-
# vi: set ft=ruby :


#VBoxManage list systemproperties | grep "Default machine folder:"
#VBoxManage setproperty machinefolder


# define config.yaml with content:
#---
#user:
#    name: utamas
#    passwd: 
#kernel: v3.14.1-trusty
#country: hu

require 'yaml'
configuration = YAML.load_file('config.yaml')

VAGRANT_COMMAND = ARGV[0]

Vagrant.configure(2) do |config|


  config.vm.define "utamas" do |utamas|
    utamas.vm.box = "ubuntu/trusty64"
    utamas.vm.box_check_update = true

    utamas.vm.network "private_network", ip: "192.168.200.100"

    utamas.vm.synced_folder "./share/", "/home/vagrant/utamas"

    utamas.vm.provider "virtualbox" do |vb|
      vb.name = "utamas"
      vb.memory = "2048"
    end

    utamas.vm.provision "shell" do |script|
      script.path = "provision/utamas-update-kernel.sh"
      script.args = ["#{configuration['user']['name']}", "#{configuration['user']['passwd']}", "#{configuration['country']}", "#{configuration['kernel']}"]
    end

    #utamas.vm.provision :reload

    #utamas.vm.provision "shell" do |script|
    #  script.path = "provision/utamas-install.sh"
    #  script.args = ["#{configuration['service']['dns']['rootPassword']}"]
    #end

  end
end
