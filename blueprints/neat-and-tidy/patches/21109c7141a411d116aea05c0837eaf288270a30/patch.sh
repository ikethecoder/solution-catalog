#!/bin/bash

# Defect #01 : go/appuser need access to the same location

mkdir -p /opt/applications/working/logs

chown -R go:appgrp /opt/applications
chown -R appuser:appgrp /opt/applications/working

# Defect #02 : Java Home is not getting set globally

cp ./java.sh /etc/profile.d/.

# Defect #03 : droplet kit was missed from the image

gem install droplet_kit --no-ri --no-rdoc

# Defect #04 : TLS certificates for consul/vault need to be made available to go

mkdir -p /var/go/ssl
cp /etc/consul.d/ssl/ca.cert /var/go/ssl/ca.cert
cp /etc/consul.d/ssl/consul.cert /var/go/ssl/consul.cert
cp /etc/consul.d/ssl/consul.key /var/go/ssl/consul.key
cp /etc/consul.d/ssl/vault.cert /var/go/ssl/vault.cert
cp /etc/consul.d/ssl/vault.key /var/go/ssl/vault.key
chown -R go:go /var/go/ssl

# Defect #05 : Go needs settings set to configure TLS for consul and the vault

mkdir -p /var/go/.ecosystem-catalog
cp ./config.json /var/go/.ecosystem-catalog/.
cp ./env.json /var/go/.ecosystem-catalog/.

chown -R go:go /var/go/.ecosystem-catalog


# Defect #06 : Ruby version wasn't getting picked up during systemd service start

cp ./springbootapp /usr/local/bin/springbootapp

chmod +x /usr/local/bin/springbootapp

# (doesn't really work - getting error "/usr/bin/env: ruby_executable_hooks ; file not found error")

# Defect 07 : Not getting right version; but springbootapp is giving a weird "/usr/bin/env: ruby_executable_hooks" error

curl -sSL https://get.rvm.io | sudo bash -s stable --ruby

source /usr/local/rvm/scripts/rvm
