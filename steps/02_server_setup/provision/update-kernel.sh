#!/bin/bash -e


updateKernelTo() {
	local version=${1:-v4.3.3-wily}

	cd /vagrant/share

	#filesToDownload=$(lynx -dump -listonly -dont-wrap-pre http://kernel.ubuntu.com/~kernel-ppa/mainline/$version/ | egrep "(generic|all)" | egrep  '(image|headers)' | egrep '(amd64|all)' | cut -d ' ' -f 4)

	wget $(lynx -dump -listonly -dont-wrap-pre http://kernel.ubuntu.com/~kernel-ppa/mainline/$version/ | egrep "(generic|all)" | egrep  '(image|headers)' | egrep '(amd64|all)' | cut -d ' ' -f 4)

	#dpkg -i *.deb
}

setupServer() {
	#local userName=$1; shift
	#local passwd=$1; shift
	#local country=${1:-hu}; shift
	local kernelVersion=${4}; shift

	#if [[ -n "$kernelVersion" ]]; then
	#	echo "updating kernel"
	#	updateKernelTo "$kernelVersion"
	#fi
}

setupServer "$@"