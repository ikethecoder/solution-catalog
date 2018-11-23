#!/bin/bash -e

export KEYCLOAK_HOME=`pwd`/keycloak
export PATH=$PATH:$KEYCLOAK_HOME/bin

keycloak/bin/kcadm.sh config credentials --server $KEYCLOAK_URL/auth --realm master --user $KEYCLOAK_USER --client admin-cli --password $KEYCLOAK_PASSWORD

keycloak/bin/kcadm.sh create realms -s realm=ecosystem -s enabled=true -o

CID=$(kcadm.sh create clients -r ecosystem -s clientId=gitea -s enabled=true -s clientAuthenticatorType=client-secret -s secret=$KEYCLOAK_CLIENT_SECRET -s "redirectUris=[\"http://*\",\"https://*\"]" -i)

