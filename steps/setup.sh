#!/bin/bash -e


# vboxmanage list vms
function createBox() {
	local -r boxname=${1:-'hawk1222'}; shift

	local -r logFile=/tmp/hawk1222-setup.log

	(
		cd 01_create_basic_vagrant_image

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
			vagrant box remove $boxname --all --force >> $logFile
		fi
		vagrant box add $boxname $boxname.box >> $logFile
	)
}

function setupServer() {
	local -r logFile=/tmp/hawk1222-setup.log

	(
		cd 02_server_setup

		echo "Deleting VM"
		vagrant destroy --force >> $logFile

		echo "Provisioning VM"
		vagrant up --provision >> $logFile
	)
}

createBox "$@" \
	&& setupServer