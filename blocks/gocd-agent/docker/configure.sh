
docker rm -f gocd-agent || true

echo "HOSTNAME=$HOSTNAME"

docker create --name gocd-agent --net=vlan0 -v /var/local/gocd/home:/home/go -e AGENT_AUTO_REGISTER_KEY=$HOSTNAME -e AGENT_AUTO_REGISTER_RESOURCES="" -e AGENT_AUTO_REGISTER_ENVIRONMENTS="" -e AGENT_AUTO_REGISTER_HOSTNAME=$HOSTNAME -e GO_SERVER_URL=$SERVICE_GOCD_SP_GOCD_ADMIN_CREDENTIALS_URL gocd/gocd-agent-alpine-3.6:v18.10.0
