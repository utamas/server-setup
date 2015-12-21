#!/bin/bash -e

apt-get udpate

apt-get install -y software-properties-common
apt-get install apt-transport-https


installDocker() {
	sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
	rm -rf /etc/apt/sources.list.d/docker.list
	echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" | sudo tee /etc/apt/sources.list.d/docker.list
	apt-get update
	#apt-get install linux-image-extra-$(uname -r)
	apt-get install linux-image-extra-3.13.0-41-generic
	apt-get purge lxc-docker
	apt-cache policy docker-engine
	apt-get update
	sudo apt-get install -y docker-engine
}