

docker create --name keycloak -e DB_VENDOR=postgres -e DB_ADDR=postgres -e DB_PORT=5432 -e DB_USER=postgres -e DB_PASSWORD=mysecretpassword -e DB_DATABASE=keycloak2 -e PROXY_ADDRESS_FORWARDING=true jboss/keycloak:4.1.0.Final

