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


  config.vm.define "gitlab" do |gitlab|
    gitlab.vm.box = "ubuntu/trusty64"
    gitlab.vm.box_check_update = true

    gitlab.vm.network "private_network", ip: "192.168.200.100"

    gitlab.vm.synced_folder "./utamas/", "/home/vagrant/utamas"

    gitlab.vm.provider "virtualbox" do |vb|
      vb.name = "gitlab"
      vb.memory = "2048"
    end

    gitlab.vm.provision "shell" do |script|
      script.path = "provision/utamas-update-kernel.sh"
      script.args = ["#{configuration['user']['name']}", "#{configuration['user']['passwd']}", "#{configuration['country']}", "#{configuration['kernel']}"]
    end

    gitlab.vm.provision :reload

    gitlab.vm.provision "shell" do |script|
      script.path = "provision/utamas-install.sh"
    end

  end

  config.vm.define "sandbox" do |sandbox|
    sandbox.vm.box = "ubuntu/trusty64"
    sandbox.vm.box_check_update = true

    sandbox.vm.network "private_network", ip: "192.168.200.100"

    sandbox.vm.synced_folder "./utamas/", "/home/vagrant/utamas"

    sandbox.vm.provider "virtualbox" do |vb|
      vb.name = "sandbox"
      vb.memory = "1024"
    end
  end
end
