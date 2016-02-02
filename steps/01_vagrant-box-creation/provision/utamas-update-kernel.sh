#!/bin/bash -e

replaceSourceList() {
	local country=$1
	local sources=/etc/apt/sources.list
	local url=http://us.archive.ubuntu.com/ubuntu/

	if [[ "$country" = "hu" ]]; then
		url=http://hu.archive.ubuntu.com/ubuntu/
	fi

	echo "deb $url trusty main restricted universe multiverse" | sudo tee $sources
	echo "deb $url trusty-security main restricted universe multiverse" | sudo tee -a $sources
	echo "deb $url trusty-updates main restricted universe multiverse" | sudo tee -a $sources

	echo "deb http://archive.canonical.com/ubuntu trusty partner" | sudo tee -a $sources
	echo "deb http://extras.ubuntu.com/ubuntu trusty main" | sudo tee -a $sources
	#echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | sudo tee -a $sources

	echo "deb-src $url trusty main restricted universe multiverse" | sudo tee -a $sources
	echo "deb-src $url trusty-security main restricted universe multiverse" | sudo tee -a $sources
	echo "deb-src $url trusty-updates main restricted universe multiverse" | sudo tee -a $sources

	sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886
	sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 16126D3A3E5C1192
}

installBasics() {
	apt-get -y update
	apt-get -y install ntp curl mc vim htop apt-transport-https lynx
}


installUser() {
	local USERNAME=$1
	local PASS=$2
	sudo useradd -p $(openssl passwd -1 $PASS) $USERNAME -g sudo
}

updateKernelTo() {
	local version=${1:-v4.3.3-wily}

	rm -rf /tmp/kernel-update
	mkdir -p /tmp/kernel-update
	cd /tmp/kernel-update

	wget $(lynx -dump -listonly -dont-wrap-pre http://kernel.ubuntu.com/~kernel-ppa/mainline/$version/ | egrep "(generic|all)" | egrep  '(image|headers)' | egrep '(amd64|all)' | cut -d ' ' -f 4)

	dpkg -i *.deb
}

setupServer() {
	local userName=$1
	local passwd=$2
	local country=${3:-hu}
	#local updateKernel=${4:-false}
	local kernelVersion=${4}

	echo "Setting up server: apt-source country: $country, updating kernel to $kernelVersion."

	replaceSourceList "$country" \
		&& installBasics \
		&& installUser $userName $passwd

	if [[ -n "$kernelVersion" ]]; then
		echo "updating kernel"
		updateKernelTo "$kernelVersion"
	fi
}

setupServer "$@"