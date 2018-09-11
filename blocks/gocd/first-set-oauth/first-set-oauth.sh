#!/bin/bash

docker run $MODE \
  -v `pwd`:/screenshots \
  -v `pwd`/blocks/gocd/first-set-oauth/scripts:/tests \
  -e ENV=local \
  -e APP_LOCAL_GOCD_URL="$GOCD_URL" \
  -e OAUTH_CLIENTS_GOCD_OAUTH2_ROOT_URL="$OAUTH_CLIENTS_GOCD_OAUTH2_ROOT_URL" \
  -e OAUTH_CLIENTS_GOCD_CLIENT_SECRET="$OAUTH_CLIENTS_GOCD_CLIENT_SECRET" \
  tester

