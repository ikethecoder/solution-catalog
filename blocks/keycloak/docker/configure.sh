

docker run --net=vlan0 -v $CATALOG_LOCATION/blocks/keycloak/docker/config:/work postgres:9.6.9 psql postgresql://postgres:mysecretpassword@ocwa_postgres -f /work/setup.psql
