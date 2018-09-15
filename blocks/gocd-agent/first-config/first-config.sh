#!/bin/bash

set -e

canzea --lifecycle=wire \
  --solution=ecosystem \
  --action=config \
  --args='{"source":"{{CATALOG_LOCATION}}/blocks/gocd-agent/first-config/config/.gitconfig.mustache","target":"/var/go/.gitconfig","instanceId":"{{HOSTNAME}}","solution":"gocd-agent"}'

canzea --lifecycle=wire \
  --solution=ecosystem \
  --action=config \
  --args='{"source":"{{CATALOG_LOCATION}}/blocks/gocd-agent/first-config/config/.git-credentials.mustache","target":"/var/go/.git-credentials","instanceId":"{{HOSTNAME}}","solution":"gocd-agent"}'

chmod 644 /var/go/.git*

systemctl stop go-agent && systemctl start go-agent