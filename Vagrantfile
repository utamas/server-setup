# -*- mode: ruby -*-
# vi: set ft=ruby :

#Vagrant.require_plugin "vagrant-reload"

#REQUIRED_PLUGINS = %w(vagrant-reload)

uid = `id -u`.gsub("\n",'')
gid = `id -g`.gsub("\n",'')
user = `whoami`.gsub("\n",'')
group = `less /etc/group | grep :#{gid}: | tr ':' ' ' | cut -f1 -d " "`.gsub("\n", '')
passwd = ""

#p "#{uid} #{gid} #{user} #{group}"

VAGRANT_COMMAND = ARGV[0]

Vagrant.configure(2) do |config|

  config.vm.define "utamas" do |utamas|
    utamas.vm.box = "ubuntu/precise64"
    utamas.vm.box_check_update = true

    utamas.vm.network "private_network", ip: "192.168.200.101"
    #utamas.vm.network "forwarded_port", guest: 9000, host: 9000
    #utamas.vm.network "forwarded_port", guest: 9100, host: 9100
    #utamas.vm.network "forwarded_port", guest: 9200, host: 9200

    utamas.vm.hostname = "utamas"

    utamas.vm.synced_folder "./utamas/", "/home/vagrant/utamas"

    utamas.vm.provider "virtualbox" do |vb|
      vb.name = "utamas"
      vb.memory = "1024"
    end

    utamas.vm.provision "shell" do |script|
      script.path = "provision/utamas-update-kernel.sh"
      script.args = ["#{user}", "#{passwd}"]
    end

    #config.vm.provision :reload

    utamas.vm.provision "shell" do |script|
      script.path = "provision/utamas-install.sh"
      script.args = ["#{uid}", "#{gid}", "#{user}", "#{group}"]
    end

  end

  config.vm.define "gitlab" do |gitlab|
    gitlab.vm.box = "ubuntu/precise64"
    gitlab.vm.box_check_update = true

    gitlab.vm.network "private_network", ip: "192.168.200.102"
    #gitlab.vm.network "forwarded_port", guest: 8000, host: 8000
    #gitlab.vm.network "forwarded_port", guest: 9100, host: 9100
    #gitlab.vm.network "forwarded_port", guest: 9200, host: 9200

    gitlab.vm.hostname = "gitlab"

    gitlab.vm.synced_folder "./utamas/", "/home/vagrant/utamas"

    gitlab.vm.provider "virtualbox" do |vb|
      vb.name = "gitlab"
      vb.memory = "1024"
    end
  end
end
