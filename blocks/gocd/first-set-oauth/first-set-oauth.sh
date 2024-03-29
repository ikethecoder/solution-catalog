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
  -v $CATALOG_LOCATION/:/screenshots \
  -v $CATALOG_LOCATION/blocks/gocd/first-set-oauth/scripts:/tests \
  -e ENV=local \
  -e GOCD_ADDRESS \
  -e GOCD_PORT \
  -e SERVICE_GOCD_SP_GOCD_ADMIN_CREDENTIALS_PASSWORD \
  -e OAUTH_CLIENTS_GOCD_OAUTH2_ROOT_URL \
  -e OAUTH_CLIENTS_GOCD_CLIENT_SECRET \
  canzea/tester:0.1.13

docker rm -f selenium || true

docker network rm vlan1
