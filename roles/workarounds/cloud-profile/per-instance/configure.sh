#!/bin/bash

echo "Hello World.  The time is now $(date -R)!" | tee -a /root/output.txt

(mkdir -p /root/bkup && mv /root/*.log /root/bkup)

export HOME=/root
export CONSUL_URL=http://10.136.0.48:8500
export VAULT_TOKEN=abcd

export HOSTNAME=`curl -s http://169.254.169.254/metadata/v1/hostname`
export PUBLIC_IPV4=`curl -s http://169.254.169.254/metadata/v1/interfaces/public/0/ipv4/address`
export PRIVATE_IPV4=`curl -s http://169.254.169.254/metadata/v1/interfaces/private/0/ipv4/address`

# chmod +x /opt/cloud-profile/configure.sh

canzea --reset

canzea --util=apply-config --step=1 --task=1

# (/opt/cloud-profile/configure.sh >> /root/configure.log)

echo "Hello World DONE.  The time is now $(date -R)!" | tee -a /root/output.txt
