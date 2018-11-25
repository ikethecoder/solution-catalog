#!/bin/bash -e

(cd $CATALOG_LOCATION/blocks/flows-gateway/upgrade-to-oidc && docker build --tag flows-gateway.local .)

docker rm -f flows-gateway || true

rm -rf /var/local/flows-gateway/projects

mkdir -p /var/local/flows-gateway/projects

unzip -d /var/local/flows-gateway/projects $CATALOG_LOCATION/blocks/flows-gateway/upgrade-to-oidc/config/keycloak.zip
unzip -d /var/local/flows-gateway/projects $CATALOG_LOCATION/blocks/flows-gateway/upgrade-to-oidc/config/temp.zip
unzip -d /var/local/flows-gateway/projects $CATALOG_LOCATION/blocks/flows-gateway/upgrade-to-oidc/config/general.zip

chown -R pm2user:pm2user /var/local/flows-gateway/projects

docker create --name flows-gateway --net=vlan0 -p 8000:8000 \
    -e adminAuth=oauth2 \
    -e adminRoot="/gwadmin/" \
    -e ADMIN_OAUTH2_AUTHORIZE="$OAUTH_CLIENTS_GITEA_OIDC_ISSUER/protocol/openid-connect/auth" \
    -e ADMIN_OAUTH2_TOKEN="$OAUTH_CLIENTS_GITEA_OIDC_ISSUER/protocol/openid-connect/token" \
    -e ADMIN_OAUTH2_USERINFO="$OAUTH_CLIENTS_GITEA_OIDC_ISSUER/protocol/openid-connect/userinfo" \
    -e ADMIN_OAUTH2_CLIENT_ID=gitea \
    -e ADMIN_OAUTH2_CLIENT_SECRET=$OAUTH_CLIENTS_GITEA_CLIENT_SECRET \
    -e ADMIN_OAUTH2_ISSUER=$OAUTH_CLIENTS_GITEA_OIDC_ISSUER \
    -e ADMIN_OAUTH2_CALLBACK="https://$ES_DOMAIN/gwadmin/auth/strategy/callback" \
    -e ECOSYSTEM -e ECOSYSTEM_LABEL="Ecosystem Gateway" -v /var/local/flows-gateway/config.json:/home/pm2user/.node-red/.config.json -v /var/local/flows-gateway/projects:/home/pm2user/.node-red/projects -v /var/local/flows-gateway/ssl:/home/pm2user/ssl -e VAULT_TOKEN -v /var/local/consul/ssl:/etc/vault/ssl flows-gateway.local

systemctl restart flows-gateway

# -v /var/local/flows-gateway/config.json:/home/pm2user/.node-red/.config.json


# zip -r keycloak.zip keycloak

