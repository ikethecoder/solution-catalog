
docker create --name gocd-agent --net=vlan0 -e GO_SERVER_URL=$SERVICE_GOCD_SPADMIN_CREDENTIALS_URL gocd/gocd-agent-alpine-3.5:v18.10.0


