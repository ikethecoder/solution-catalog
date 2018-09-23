#!/bin/bash

set -e

canzea --lifecycle=wire \
  --solution=ecosystem \
  --action=config \
  --args='{"source":"{{CATALOG_LOCATION}}/blocks/gocd/set-credentials/config/.git-credentials.mustache","target":"/var/local/gocd/home/plus.git-credentials","instanceId":"cd-reg-01","solution":"gocd"}'

cat /var/local/gocd/home/plus.git-credentials >> /var/local/gocd/home/.git-credentials
