#!/bin/bash -e

function createBox() {
	vagrant destroy --force && vagrant provision
	vagrant reload
}

createBox "$@"