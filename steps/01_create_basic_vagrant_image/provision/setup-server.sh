#!/bin/bash -e

function replaceSourceList() {
	local -r country=$1; shift

	local -r sources=/etc/apt/sources.list
	local url=http://us.archive.ubuntu.com/ubuntu/

	if [[ "$country" = "hu" ]]; then
		url=http://hu.archive.ubuntu.com/ubuntu/
	fi

	echo "deb $url trusty main restricted universe multiverse" | sudo tee $sources
	echo "deb $url trusty-security main restricted universe multiverse" | sudo tee -a $sources
	echo "deb $url trusty-updates main restricted universe multiverse" | sudo tee -a $sources

	echo "deb http://archive.canonical.com/ubuntu trusty partner" | sudo tee -a $sources
	echo "deb http://extras.ubuntu.com/ubuntu trusty main" | sudo tee -a $sources

	echo "deb-src $url trusty main restricted universe multiverse" | sudo tee -a $sources
	echo "deb-src $url trusty-security main restricted universe multiverse" | sudo tee -a $sources
	echo "deb-src $url trusty-updates main restricted universe multiverse" | sudo tee -a $sources

	sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886
	sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 16126D3A3E5C1192
}

function installBasics() {
	sudo apt-get -yqq update
	sudo apt-get -yqq install ntp curl mc vim htop
	sudo apt-get -yqq autoremove
}

function installUser() {
	local -r username=$1; shift
	local -r password=$1; shift

	sudo useradd -p $(openssl passwd -1 $password) $username -g sudo
}

function installDocker() {
	sudo apt-get install -y apt-transport-https ca-certificates
	sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

	echo "deb https://apt.dockerproject.org/repo ubuntu-wily main" | sudo tee /etc/apt/sources.list.d/docker.list

	sudo apt-get -y update
	#sudo apt-get -y purge lxc-docker
	sudo apt-cache policy docker-engine

	sudo apt-get -y install linux-image-extra-$(uname -r)

	sudo apt-get update
	sudo apt-get -y install docker-engine
 }

function setupServer() {
	local userName=$1; shift
	local password=$1; shift
	local country=${1:-hu}; shift

	echo "Setting up server: apt-source country: $country."

	replaceSourceList "$country" \
		&& installBasics \
		&& installUser $userName $ \
		&& installDocker
}

setupServer "$@"