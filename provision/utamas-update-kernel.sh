#!/bin/bash -e

replaceSourceList() {
	local sources=/etc/apt/sources.list
	echo "deb http://us.archive.ubuntu.com/ubuntu/ trusty main restricted universe" | sudo tee $sources
	echo "deb http://us.archive.ubuntu.com/ubuntu/ trusty-security main restricted universe" | sudo tee -a $sources
	echo "deb http://us.archive.ubuntu.com/ubuntu/ trusty-updates main restricted universe" | sudo tee -a $sources
	echo "deb http://archive.canonical.com/ubuntu trusty partner" | sudo tee -a $sources
	echo "deb http://extras.ubuntu.com/ubuntu trusty main" | sudo tee -a $sources
	echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | sudo tee -a $sources

	sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886
	sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 16126D3A3E5C1192
}

installBasics() {
	apt-get -y update
	apt-get -y install ntp curl mc vim htop apt-transport-https	
}

updateKernel() {
	rm -rf /tmp/kernel-update
	mkdir -p /tmp/kernel-update
	cd /tmp/kernel-update

	wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.3.3-wily/linux-headers-4.3.3-040303-generic_4.3.3-040303.201512150130_amd64.deb
	wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.3.3-wily/linux-headers-4.3.3-040303_4.3.3-040303.201512150130_all.deb
	wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.3.3-wily/linux-image-4.3.3-040303-generic_4.3.3-040303.201512150130_amd64.deb
	
	dpkg -i *.deb
}

installUser() {
	local USERNAME=$1
	local PASS=$2
	sudo useradd -p $(openssl passwd -1 $PASS) $USERNAME sudo
}

setupServer() {
	local userName=$1
	local passwd=$2

	replaceSourceList && installBasics && updateKernel
}

setupServer "$@"