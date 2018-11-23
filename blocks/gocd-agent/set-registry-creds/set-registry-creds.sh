#!/bin/bash

set -e

canzea --lifecycle=wire \
  --solution=ecosystem \
  --action=config \
  --args='{"source":"{{CATALOG_LOCATION}}/blocks/gocd-agent/set-registry-creds/config/settings.xml.tmpl","target":"/var/local/gitea/gitea/conf/app.ini","instanceId":"$HOSTNAME","solution":"maven"}'

