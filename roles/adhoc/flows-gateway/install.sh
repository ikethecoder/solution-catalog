
# docker create --name flows-gateway -p 8000:8000 -v /home/pm2user/ssl:/home/pm2user/ssl canzea/flows-gateway:0.1.1


docker create --name flows-gateway -p 8000:8000 -v /var/local/flows-gateway/ssl:/home/pm2user/ssl -e VAULT_TOKEN -v /var/local/consul/ssl:/etc/vault/ssl canzea/flows-gateway:0.1.10
