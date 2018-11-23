

docker run --net=vlan0 -v ${PWD}/blocks/keycloak/docker/config:/work postgres:9.6.9 psql postgresql://pguser:mysecretpassword@postgres -f /work/setup.psql
