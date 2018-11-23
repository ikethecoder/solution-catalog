
docker rm -f gocd-agent || true

echo "HOSTNAME=$HOSTNAME"

docker create --name gocd-agent --net=vlan0 -h $HOSTNAME -v /var/local/gocd/home:/home/go -e GO_SERVER_URL=$SERVICE_GOCD_SP_GOCD_ADMIN_CREDENTIALS_URL gocd/gocd-agent-alpine-3.6:v18.10.0
