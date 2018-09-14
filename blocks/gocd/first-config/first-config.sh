#!/bin/bash

set -e

canzea --lifecycle=wire \
  --solution=ecosystem \
  --action=config \
  --args='{"source":"{{CATALOG_LOCATION}}/blocks/gocd/first-config/config/gocd-websocket-notifier.conf","target":"/var/local/gocd/home/gocd-websocket-notifier.conf","instanceId":"cd-reg-01","solution":"gocd"}'

canzea --lifecycle=wire \
  --solution=ecosystem \
  --action=config \
  --args='{"source":"{{CATALOG_LOCATION}}/blocks/gocd/first-config/config/.gitconfig.mustache","target":"/var/local/gocd/home/.gitconfig","instanceId":"cd-reg-01","solution":"gocd"}'

canzea --lifecycle=wire \
  --solution=ecosystem \
  --action=config \
  --args='{"source":"{{CATALOG_LOCATION}}/blocks/gocd/first-config/config/.git-credentials.mustache","target":"/var/local/gocd/home/.git-credentials","instanceId":"cd-reg-01","solution":"gocd"}'

chmod 644 /var/local/gocd/home/gocd-websocket-notifier.conf /var/local/gocd/home/.git*

systemctl restart gocd

