
(cd blocks/flows-gateway/docker && docker build --tag local_gw .)

docker create --name flows-gateway -p 8000:8000 -e ECOSYSTEM -e ECOSYSTEM_LABEL="Ecosystem Gateway" -v /var/local/flows-gateway/flows.json:/home/pm2user/.node-red/flows.json -v /var/local/flows-gateway/ssl:/home/pm2user/ssl -e VAULT_TOKEN -v /var/local/consul/ssl:/etc/vault/ssl local_gw

#      export ADMIN_OAUTH2_AUTHORIZE=http://localhost:8000/gw/oauth/authorize
#      export ADMIN_OAUTH2_TOKEN=http://localhost:8000/gw/oauth/token
#      export ADMIN_OAUTH2_USERINFO=http://localhost:8000/gw/me
#      export ADMIN_OAUTH2_CLIENT_ID=flows
#      export ADMIN_OAUTH2_CLIENT_SECRET=11-11-11-11
#      export ADMIN_OAUTH2_CALLBACK=http://localhost:8000/auth/strategy/callback
