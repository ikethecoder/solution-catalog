#!/bin/bash

set -e

canzea --lifecycle=wire \
  --solution=ecosystem \
  --action=config \
  --args='{"source":"{{CATALOG_LOCATION}}/blocks/gitea/docker/config/app.ini","target":"/var/local/gitea/gitea/conf/app.ini","instanceId":"cd-reg-01","solution":"gitea"}'

systemctl restart gitea

