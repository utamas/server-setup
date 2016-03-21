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
	# there will be one nginx connectected to bridge network
	local -r networkName=apol.lo
	local -r hostIp=42.42.42.42
	local -r googleDnsIp=8.8.8.8
	local -r sharedFolder=/vagrant/shared
	local -r bindFolder=$sharedFolder/sameersbn/bind
	local -r ciServer=$sharedFolder/jenkins/home
	local -r gitServer=$sharedFolder/gitlab

	#rm -rf $bindFolder
	mkdir -p $bindFolder
	mkdir -p $ciServer

	mkdir -p www
	echo "Hello from Server 1" > www/index.html


	docker network create -d bridge --subnet 192.168.42.0/18 $networkName


	sudo docker pull sameersbn/bind:latest
	sudo docker pull jenkins
	#sudo docker pull evarga/jenkins-slave
	sudo docker pull gitlab/gitlab-ce

	#sudo docker pull gocd/gocd-server
	#sudo docker pull gocd/gocd-agent
	#sudo docker pull ubuntu
	sudo docker pull httpd:2.4

	docker run -d   --net=$networkName --dns=$googleDnsIp  --ip=192.168.42.42  --name=bind         --hostname=dns.$networkName                   \
	  -e ROOT_PASSWORD=SecretPassword \
	  --publish=$hostIp:53:53/udp --publish=8080:8080 \
	  -v $bindFolder:/data sameersbn/bind:latest

	#-p 8080:8080 -p 50000:50000
	docker run -d   --net=$networkName --dns=192.168.42.42 --ip=192.168.42.100 --name=ci-server    --hostname=ci-server.devtools.$networkName    \
	  -e JAVA_OPTS=-Dhudson.footerURL=http://ci-server.devtools.$networkName \
	  -v $ciServer:/var/jenkins_home jenkins


    #  -p 443:443 -p 80:80 -p 22:22 \
	docker run -d   --net=$networkName --dns=192.168.42.42 --ip=192.168.42.110 --name=git-server    --hostname=git.devtools.$networkName    \
      -v $gitServer/config:/etc/gitlab -v $gitServer/logs:/var/log/gitlab -v $gitServer/data:/var/opt/gitlab \
      --restart always gitlab/gitlab-ce:latest

    

    # -p 8153:8153
    #docker run -it  --net=$networkName --dns=192.168.42.42 --ip=192.168.42.100 --name=ci-server    --hostname=ci-server.devtools.$networkName    -e AGENT_KEY=527d4d558389ea70a06888fbae18a584                             gocd/gocd-server
    #docker run -it  --net=$networkName --dns=192.168.42.42 --ip=192.168.42.101 --name=ci-client-01 --hostname=ci-client-01.devtools.$networkName -e AGENT_KEY=527d4d558389ea70a06888fbae18a584 -e GO_SERVER=192.168.42.100 gocd/gocd-agent

    docker run -itd --net=$networkName --dns=192.168.42.42 --ip=192.168.42.2 --name server1 -v /root/www:/usr/local/apache2/htdocs/ --hostname=lalisuli.hu httpd:2.4

    #docker run -it  --name=sandbox --dns=192.168.42.42 --net=apollo --hostname=sandbox ubuntu /bin/bash


	return $?
}

function setupServer() {
	local -r gitLabSsh=$1; shift

	#setupFirewall $gitLabSsh \
	pullDockerImages

	#echo "Done"
}

setupServer "$@"