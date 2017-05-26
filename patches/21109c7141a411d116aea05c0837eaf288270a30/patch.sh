#!/bin/bash


mkdir -p /opt/applications/working/logs

chown -R go:appgrp /opt/applications
chown -R appuser:appgrp /opt/applications/working


mkdir -p /Users/aidancope
chown -R appuser:appgrp /Users/aidancope

gem install droplet_kit


mkdir -p /var/go/ssl
cp /etc/consul.d/ssl/ca.cert /var/go/ssl/ca.cert
cp /etc/consul.d/ssl/consul.cert /var/go/ssl/consul.cert
cp /etc/consul.d/ssl/consul.key /var/go/ssl/consul.key
cp /etc/consul.d/ssl/vault.cert /var/go/ssl/vault.cert
cp /etc/consul.d/ssl/vault.key /var/go/ssl/vault.key

chown -R go:go /var/go/ssl

cp ./config.json ~/.ecosystem-catalog/.
cp ./env.json ~/.ecosystem-catalog/.

