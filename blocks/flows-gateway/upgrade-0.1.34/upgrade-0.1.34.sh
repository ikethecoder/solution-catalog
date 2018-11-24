#!/bin/bash -e

docker rm -f flows-gateway || true

docker create --name flows-gateway -p 8000:8000 \
    -e adminAuth=oauth2 \
    -e adminRoot="/gwadmin/" \
    -e ADMIN_OAUTH2_AUTHORIZE="$OAUTH_CLIENTS_GITEA_OIDC_ISSUER/protocol/openid-connect/auth" \
    -e ADMIN_OAUTH2_TOKEN="$OAUTH_CLIENTS_GITEA_OIDC_ISSUER/protocol/openid-connect/token" \
    -e ADMIN_OAUTH2_USERINFO="$OAUTH_CLIENTS_GITEA_OIDC_ISSUER/protocol/openid-connect/userinfo" \
    -e ADMIN_OAUTH2_CLIENT_ID=gitea \
    -e ADMIN_OAUTH2_CLIENT_SECRET=$OAUTH_CLIENTS_GITEA_CLIENT_SECRET \
    -e ADMIN_OAUTH2_ISSUER=$OAUTH_CLIENTS_GITEA_OIDC_DISCOVERY \
    -e ADMIN_OAUTH2_CALLBACK="https://$ES_DOMAIN/gwadmin/auth/strategy/callback" \
    -e ECOSYSTEM -e ECOSYSTEM_LABEL="Ecosystem Gateway" -v /var/local/flows-gateway/flows.json:/home/pm2user/.node-red/flows.json -v /var/local/flows-gateway/ssl:/home/pm2user/ssl -e VAULT_TOKEN -v /var/local/consul/ssl:/etc/vault/ssl canzea/flows-gateway:0.1.34

