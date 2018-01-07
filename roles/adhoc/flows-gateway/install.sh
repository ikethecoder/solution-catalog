
(cd roles/adhoc/flows-gateway && docker build --tag local_gw .)

docker create --name flows-gateway -p 8000:8000 -e ECOSYSTEM -v /var/local/flows-gateway/flows.json:/home/pm2user/.node-red/flows.json -v /var/local/flows-gateway/ssl:/home/pm2user/ssl -e VAULT_TOKEN -v /var/local/consul/ssl:/etc/vault/ssl local_gw
