#!/bin/bash -e


# vboxmanage list vms
function createBox() {
	local logFile=/tmp/kernel-update.log

	echo "" > $logFile
	echo "Deleting VM"
	vagrant destroy --force >> $logFile
	echo "Provisioning VM"
	vagrant up --provision >> $logFile
	echo "Restarting VM"
	vagrant reload  >> $logFile
	echo "Shutting down VM"
	vagrant halt >> $logFile
	#echo "Creating box"
	#vagrant package --base hawk1222 --output hawk1222.box
}

createBox "$@"