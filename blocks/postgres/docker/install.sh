

docker create --name postgres --net=vlan0 -e POSTGRES_USER=pguser -e POSTGRES_PASSWORD=mysecretpassword -v /var/local/postgres/data:/var/lib/postgresql/data postgres:9.6.9
