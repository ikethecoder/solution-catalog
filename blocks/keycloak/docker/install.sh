
(cd blocks/keycloak/docker && docker build --tag keycloak.local .)

docker create --name keycloak -p 7080:8080 --net=vlan0 -e KEYCLOAK_USER=kcadmin -e KEYCLOAK_PASSWORD=kcadmin#1 -e DB_VENDOR=postgres -e DB_ADDR=postgres -e DB_PORT=5432 -e DB_USER=appuser -e DB_PASSWORD=appuser#1 -e DB_DATABASE=keycloak -e PROXY_ADDRESS_FORWARDING=true keycloak.local

