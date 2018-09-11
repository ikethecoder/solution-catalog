#!/bin/bash

docker network create \
  --driver=bridge \
  --subnet=4.1.0.0/16 \
  --ip-range=4.1.5.0/24 \
  vlan1

docker run --net=vlan1 -d -p 4444:4444 --name selenium -v /dev/shm:/dev/shm selenium/standalone-chrome

sleep 5

docker run --net=vlan1 --rm \
  -v `pwd`:/screenshots \
  -v `pwd`/blocks/gocd/first-set-oauth/scripts:/tests \
  -e ENV=local \
  -e APP_LOCAL_GITEA_URL="$GITEA_URL" \
  -e SERVICES_GOCD_SP_GOCD_ADMIN_CREDENTIALS_USER_NAME \
  -e SERVICES_GOCD_SP_GOCD_ADMIN_CREDENTIALS_PASSWORD \
  -e OAUTH_CLIENTS_GITEA_OAUTH2_AUTHORIZE \
  -e OAUTH_CLIENTS_GITEA_OAUTH2_TOKEN \
  -e OAUTH_CLIENTS_GITEA_OAUTH2_PROFILE \
  -e OAUTH_CLIENTS_GITEA_CLIENT_SECRET \
  canzea/tester:0.1.3

docker rm -f selenium || true

docker network rm vlan1
