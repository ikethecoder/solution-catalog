#!/bin/bash

set -e

docker rm -f flows-gateway

(cd blocks/flows-gateway/docker && docker build --tag local_gw .)

docker create --name flows-gateway -p 8000:8000 -e ECOSYSTEM -e ECOSYSTEM_LABEL="Ecosystem Gateway" -e ADMIN_OAUTH2_CALLBACK=${FLOWS_GATEWAY_URL}/auth/strategy/callback -e ADMIN_OAUTH2_CLIENT_ID=flows-gateway -e ADMIN_OAUTH2_CLIENT_SECRET=$OAUTH_CLIENTS_FLOWS_GATEWAY_CLIENT_SECRET -e ADMIN_OAUTH2_AUTHORIZE=$OAUTH_CLIENTS_FLOWS_GATEWAY_OAUTH2_AUTHORIZE -e ADMIN_OAUTH2_TOKEN=$OAUTH_CLIENTS_FLOWS_GATEWAY_OAUTH2_TOKEN -e ADMIN_OAUTH2_USERINFO=$OAUTH_CLIENTS_FLOWS_GATEWAY_OAUTH2_USERINFO -v /var/local/flows-gateway/flows.json:/home/pm2user/.node-red/flows.json -v /var/local/flows-gateway/ssl:/home/pm2user/ssl -e VAULT_TOKEN -v /var/local/consul/ssl:/etc/vault/ssl local_gw

# -e ADMIN_OAUTH2_CALLBACK=${FLOWS_GATEWAY_URL}/auth/strategy/callback -e ADMIN_OAUTH2_CLIENT_ID=flows-gateway -e ADMIN_OAUTH2_CLIENT_SECRET=$OAUTH_CLIENTS_FLOWS_GATEWAY_CLIENT_SECRET -e ADMIN_OAUTH2_AUTHORIZE=$OAUTH_CLIENTS_FLOWS_GATEWAY_OAUTH2_AUTHORIZE -e ADMIN_OAUTH2_TOKEN=$OAUTH_CLIENTS_FLOWS_GATEWAY_OAUTH2_TOKEN -e ADMIN_OAUTH2_USERINFO=$OAUTH_CLIENTS_FLOWS_GATEWAY_OAUTH2_USERINFO
#      export ADMIN_OAUTH2_AUTHORIZE=http://localhost:8000/gw/oauth/authorize
#      export ADMIN_OAUTH2_TOKEN=http://localhost:8000/gw/oauth/token
#      export ADMIN_OAUTH2_USERINFO=http://localhost:8000/gw/me
#      export ADMIN_OAUTH2_CLIENT_ID=flows
#      export ADMIN_OAUTH2_CLIENT_SECRET=11-11-11-11
#      export ADMIN_OAUTH2_CALLBACK=http://localhost:8000/auth/strategy/callback


systemctl restart flows-gateway

