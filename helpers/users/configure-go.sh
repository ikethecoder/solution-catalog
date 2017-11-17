#!/bin/bash

mkdir /var/go/ssl
cp /var/local/consul/ssl/ca.cert /var/go/ssl/ca.cert
cp /var/local/consul/ssl/consul.cert /var/go/ssl/consul.cert
cp /var/local/consul/ssl/consul.key /var/go/ssl/consul.key
cp /var/local/consul/ssl/vault.cert /var/go/ssl/vault.cert
cp /var/local/consul/ssl/vault.key /var/go/ssl/vault.key

chown -R go:go /var/go/ssl

su -l go -c 'canzea --reset'

cp $CATALOG_LOCATION/helpers/users/config/go-config.json /var/go/.ecosystem-catalog/config.json

cp $CATALOG_LOCATION/helpers/users/config/go-env.json /var/go/.ecosystem-catalog/env.json

chown -R go:go /var/go/.ecosystem-catalog


mkdir -p /opt/applications/working

adduser -m appuser

groupadd appgrp

# Have go:go as the primary user
chown -R go:appgrp /opt/applications

chown -R appuser:appgrp /opt/applications/working
