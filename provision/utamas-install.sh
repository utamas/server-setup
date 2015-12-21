#!/bin/bash -e

installDocker() {
	sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
	echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" | sudo tee /etc/apt/sources.list.d/docker.list
	apt-get update
	apt-get purge -y lxc-docker
	apt-cache policy docker-engine
	apt-get install -y linux-image-extra-4.2.0-19-generic
	apt-get update -y
	apt-get install -y docker-engine
}

installSquid() {
	flushSquidConfiguration() {
		echo "#  include /path/to/included/file/squid.acl.config" | sudo tee -a /etc/squid3/squid.conf
		echo "#acl localnet src 92.249.130.54" | sudo tee -a /etc/squid3/squid.conf

		echo "acl SSL_ports port 443" | sudo tee -a /etc/squid3/squid.conf

		echo "# http" | sudo tee -a /etc/squid3/squid.conf
		echo "acl Safe_ports port 80" | sudo tee -a /etc/squid3/squid.conf
		echo "# https" | sudo tee -a /etc/squid3/squid.conf
		echo "acl Safe_ports port 443" | sudo tee -a /etc/squid3/squid.conf

		echo "acl CONNECT method CONNECT" | sudo tee -a /etc/squid3/squid.conf

		echo "http_access deny !Safe_ports" | sudo tee -a /etc/squid3/squid.conf

		echo "http_access deny CONNECT !SSL_ports" | sudo tee -a /etc/squid3/squid.conf

		echo "http_access allow localhost manager" | sudo tee -a /etc/squid3/squid.conf
		echo "http_access allow localnet" | sudo tee -a /etc/squid3/squid.conf
		echo "http_access deny manager" | sudo tee -a /etc/squid3/squid.conf
		echo "http_access allow localhost" | sudo tee -a /etc/squid3/squid.conf

		echo "# And finally deny all other access to this proxy" | sudo tee -a /etc/squid3/squid.conf
		echo "http_access deny all" | sudo tee -a /etc/squid3/squid.conf

		echo "# Squid normally listens to port 3128" | sudo tee -a /etc/squid3/squid.conf
		echo "http_port 1986" | sudo tee -a /etc/squid3/squid.conf

		echo "# Leave coredumps in the first cache dir" | sudo tee -a /etc/squid3/squid.conf
		echo "coredump_dir /var/spool/squid3" | sudo tee -a /etc/squid3/squid.conf

		echo "#" | sudo tee -a /etc/squid3/squid.conf
		echo "# Add any of your own refresh_pattern entries above these." | sudo tee -a /etc/squid3/squid.conf
		echo "#" | sudo tee -a /etc/squid3/squid.conf
		echo "refresh_pattern ^ftp:		1440	20%	10080" | sudo tee -a /etc/squid3/squid.conf
		echo "refresh_pattern ^gopher:	1440	0%	1440" | sudo tee -a /etc/squid3/squid.conf
		echo "refresh_pattern -i (/cgi-bin/|\?) 0	0%	0" | sudo tee -a /etc/squid3/squid.conf
		echo "refresh_pattern (Release|Packages(.gz)*)$      0       20%     2880" | sudo tee -a /etc/squid3/squid.conf
		echo "# example lin deb packages" | sudo tee -a /etc/squid3/squid.conf
		echo "#refresh_pattern (\.deb|\.udeb)$   129600 100% 129600" | sudo tee -a /etc/squid3/squid.conf
		echo "refresh_pattern .		0	20%	4320" | sudo tee -a /etc/squid3/squid.conf
	}

	sudo apt-get install squid@3.3.8
	sudo mv /etc/squid3/squid.conf /etc/squid3/squid.conf_bckp
	sudo touch /etc/squid3/squid.conf

	flushSquidConfiguration

	sudo service squid3 restart
}

#installChefServer() {
#}

startingServices() {
	#--publish 2222:22 \
	docker run --detach \
    	--hostname gitlab.example.com \
    	--publish 8443:443 --publish 8080:80 \
    	--name gitlab \
    	--restart always \
    	--volume /srv/gitlab/config:/etc/gitlab \
    	--volume /srv/gitlab/logs:/var/log/gitlab \
    	--volume /srv/gitlab/data:/var/opt/gitlab \
    	gitlab/gitlab-ce:latest
}

setupServer() {
	installDocker
}

setupServer "$@"