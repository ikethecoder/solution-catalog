#!/bin/bash

set -e

mkdir -p /var/local/gocd/home

canzea --lifecycle=wire \
  --solution=ecosystem \
  --action=config \
  --args='{"source":"{{CATALOG_LOCATION}}/blocks/gocd-agent/first-config/config/.gitconfig.mustache","target":"/var/local/gocd/home/.gitconfig","instanceId":"{{HOSTNAME}}","solution":"gocd-agent"}'

canzea --lifecycle=wire \
  --solution=ecosystem \
  --action=config \
  --args='{"source":"{{CATALOG_LOCATION}}/blocks/gocd-agent/first-config/config/.git-credentials.mustache","target":"/var/local/gocd/home/.git-credentials","instanceId":"{{HOSTNAME}}","solution":"gocd-agent"}'

chmod 644 /var/local/gocd/home/.git*

systemctl stop go-agent && systemctl start go-agent
