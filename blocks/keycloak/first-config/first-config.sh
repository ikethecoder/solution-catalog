#!/bin/bash

set -e

export KEYCLOAK_USER=kcadmin
export KEYCLOAK_PASSWORD=kcadmin#1
export KEYCLOAK_CLIENT_SECRET=11-11-11-11

docker run --net=vlan0 -e KEYCLOAK_USER -e KEYCLOAK_PASSWORD -e KEYCLOAK_CLIENT_SECRET -v $CATALOG_LOCATION/blocks/keycloak/first-config:/work --entrypoint /bin/bash jboss/keycloak:4.1.0.Final -c /work/keycloak-setup.sh"
