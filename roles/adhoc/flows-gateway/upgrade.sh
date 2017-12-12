

docker rm -f flows-gateway

docker create --name flows-gateway -p 8000:8000 -v /var/local/flows-gateway/ssl:/home/pm2user/ssl -e VAULT_TOKEN -v /var/local/consul/ssl:/etc/vault/ssl canzea/flows-gateway:0.1.19

systemctl start flows-gateway

cp .ecosystem-catalog/catalog/blueprints/neat-and-tidy/flows/flows-e52e138766dcfa7715b7f582a00d8f0d.zip .

mkdir -p temp && (cd temp && unzip ../flows-*.zip)


(cd temp && canzea --lifecycle=wire --solution=nodered --action=flows --args='{"file":"nr-tab-id-global.flow"}')
(cd temp && canzea --lifecycle=wire --solution=nodered --action=flows --args='{"file":"nr-tab-*.flow"}')
