#!/bin/bash

set -e

docker rm -f selenium || true && docker network rm vlan1 || true

docker network create \
  --driver=bridge \
  --subnet=4.1.0.0/16 \
  --ip-range=4.1.5.0/24 \
  vlan1

docker run --net=vlan1 -d -p 4444:4444 --name selenium -v /dev/shm:/dev/shm selenium/standalone-chrome

sleep 5

docker run --net=vlan1 --rm \
  -v /tmp:/screenshots \
  -v $CATALOG_LOCATION/blocks/rocketchat/first-login/scripts:/tests \
  -e ENV=local \
  -e APP_LOCAL_ROCKETCHAT_URL="$ROCKETCHAT_URL" \
  -e SERVICE_ROCKETCHAT_ESADMIN_CREDENTIALS_URL \
  -e SERVICE_ROCKETCHAT_ESADMIN_CREDENTIALS_EMAIL \
  -e SERVICE_ROCKETCHAT_ESADMIN_CREDENTIALS_USER_NAME \
  -e SERVICE_ROCKETCHAT_ESADMIN_CREDENTIALS_PASSWORD \
  canzea/tester:0.1.13

docker rm -f selenium || true

docker network rm vlan1
