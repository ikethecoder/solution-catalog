

docker rm -f gocd-agent || true

echo "HOSTNAME=$HOSTNAME"

canzea --lifecycle=wire --solution=ecosystem --action=config --args='{"source":"{{CATALOG_LOCATION}}/blocks/gocd-agent/docker/config/docker-run.sh","target":"/var/local/gocd/home/docker-run","instanceId":"{{HOSTNAME}}","solution":"gocd-agent"}'

chmod +x /var/local/gocd/home/docker-run

docker create --name gocd-agent --link dind:docker -h $HOSTNAME -v /var/local/gocd/home:/home/go -v /var/local/gocd/home:/usr/local/bin -e GO_SERVER_URL=https://${GOCD_ADDRESS}:8154/go gocd-agent.local
