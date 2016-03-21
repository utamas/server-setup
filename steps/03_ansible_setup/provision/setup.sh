#!/bin/bash
set -e

function installAnsible() {
	sudo apt-get install -y software-properties-common
	sudo apt-add-repository ppa:ansible/ansible
	sudo apt-get update
	sudo apt-get install ansible -y

	#sudo apt-get -y install apparmor python-pip python-dev
	#sudo pip install docker-py
}

function generateKey() {
	mkdir -p /home/vagrant/.ssh
	mkdir /vagrant/tmp
	ssh-keygen -f /home/vagrant/.ssh/id_rsa -t rsa -N ''

	chown vagrant:vagrant /home/vagrant/.ssh/id_rsa*
	chmod 600 /home/vagrant/.ssh/id_rsa*

	cp /home/vagrant/.ssh/id_rsa.pub /vagrant/tmp
}

function setup() {
	installAnsible && generateKey
}

setup "$@"