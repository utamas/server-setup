#!/bin/bash

set -e

mkdir -p /root/.ssh/

cat /home/vagrant/.ssh/authorized_keys_ >> /home/vagrant/.ssh/authorized_keys
cat /home/vagrant/.ssh/authorized_keys_ >> /root/.ssh/authorized_keys

rm -f /home/vagrant/.ssh/authorized_keys_