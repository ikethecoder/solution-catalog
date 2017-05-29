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

# FIX: Changed the console-app to make CLI location configurable

cp ./canzea /home/appuser/canzea
chmod +x /home/appuser/canzea
chown appuser:appgrp /home/appuser/canzea

# NOTE: springbootapp is a BUST
