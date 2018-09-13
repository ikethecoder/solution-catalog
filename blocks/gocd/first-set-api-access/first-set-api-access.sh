#!/bin/bash

set -e

docker network create \
  --driver=bridge \
  --subnet=4.1.0.0/16 \
  --ip-range=4.1.5.0/24 \
  vlan1

docker run --net=vlan1 -d -p 4444:4444 --name selenium -v /dev/shm:/dev/shm selenium/standalone-chrome

sleep 5

docker run --net=vlan1 --rm \
  -v `pwd`:/screenshots \
  -v $CATALOG_LOCATION/blocks/gocd/first-set-oauth-apis/scripts:/tests \
  -e ENV=local \
  -e APP_LOCAL_GOCD_URL="$GOCD_URL" \
  canzea/tester:0.1.3

docker rm -f selenium || true

docker network rm vlan1
