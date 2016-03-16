#!/bin/bash -e


# vboxmanage list vms
function createBox() {
	local -r boxname=${1:-'hawk1222'}; shift

	local -r logFile=/tmp/kernel-update.log

	echo "You can track progress by 'tail -f $logFile'"
	echo "" > $logFile

	echo "Deleting VM"
	vagrant destroy --force >> $logFile

	echo "Provisioning VM"
	vagrant up --provision >> $logFile

	echo "Shutting down VM"
	vagrant halt >> $logFile

	echo "Creating box"
	rm -rf $boxname.box
	vagrant package --output $boxname.box >> $logFile

	echo "Importing box"
	if [ -n "$(vagrant box list | grep $boxname)" ]; then
		vagrant box remove $boxname >> $logFile
	fi
	vagrant box add $boxname $boxname.box >> $logFile
}

createBox "$@"