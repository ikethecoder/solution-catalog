
docker rm -f gocd-agent || true

echo "HOSTNAME=$HOSTNAME"

canzea --lifecycle=wire \
  --solution=ecosystem \
  --action=config \
  --args='{"source":"{{CATALOG_LOCATION}}/blocks/gocd-agent/docker/config/docker-run.sh","target":"/var/local/gocd/home/docker-run.sh","instanceId":"{{HOSTNAME}}","solution":"gocd-agent"}'

docker create --name gocd-agent --net=vlan0 -h $HOSTNAME -v /var/local/gocd/home:/home/go -e GO_SERVER_URL=https://${GOCD_ADDRESS}:8154 gocd/gocd-agent-alpine-3.7:v18.7.0
