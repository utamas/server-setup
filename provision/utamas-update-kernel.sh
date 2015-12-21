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
	apt-get -y install ntp curl mc vim htop apt-transport-https
}

updateKernelTo_4_3_3() {
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
	sudo useradd -p $(openssl passwd -1 $PASS) $USERNAME -g sudo
}

setupServer() {
	local userName=$1
	local passwd=$2
	local country=${3:-hu}
	local updateKernel=${4:-false}

	echo "Setting up server: apt-source country: $country, updating kernel: $updateKernel."

		#&& installBasics \
	replaceSourceList "$country" \
		&& installUser $userName $passwd

	if $updateKernel; then
		updateKernelTo_4_3_3
	fi
}

setupServer "$@"