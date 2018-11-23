

docker create --name keycloak --net=vlan0 -e KEYCLOAK_USER=kcadmin -e KEYCLOAK_PASSWORD=kcadmin#1 -e DB_VENDOR=postgres -e DB_ADDR=postgres -e DB_PORT=5432 -e DB_USER=postgres -e DB_PASSWORD=mysecretpassword -e DB_DATABASE=keycloak -e PROXY_ADDRESS_FORWARDING=true jboss/keycloak:4.1.0.Final

