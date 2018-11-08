
docker exec -ti nginx certbot renew

docker exec -ti nginx nginx -s reload
