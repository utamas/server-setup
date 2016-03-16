#!/bin/bash -e

function setupFirewall() {
	local -r gitLabSsh=$1; shift

	local -r ssh=22
	local -r http=80
	local -r https=443

	local ports=($ssh $http $https $gitLabSsh)

	# Flushing firewall rules.
	sudo iptables -F
	# Enabling outgoing packets.
	sudo iptables -P OUTPUT ACCEPT
	sudo iptables -P INPUT DROP
	sudo iptables -P FORWARD DROP

	sudo iptables -A INPUT --in-interface lo -j ACCEPT

	for port in "${ports[@]}"; do
		sudo iptables -A INPUT -p tcp --dport $port -j ACCEPT
	done

	sudo iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

	sudo iptables-save > /etc/iptables.conf

	echo "post-up iptables-restore < /etc/iptables.conf" | sudo tee -a /etc/network/interfaces
}

function pullDockerImages() {
	#sudo docker pull gitlab/gitlab-ce:latest
	
	sudo docker pull gocd/gocd-server
	sudo docker pull gocd/gocd-agent
}

function setupServer() {
	local -r gitLabSsh=$1; shift

	setupFirewall $gitLabSsh \
		&& pullDockerImages
}

setupServer "$@"