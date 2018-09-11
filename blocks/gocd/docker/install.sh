

docker build --tag gocd_local blocks/gocd/docker/.

mkdir -p /var/local/gocd

docker create --name gocd -p 8154:8154 -p 8153:8153 -p 8887:8887 -v /var/local/gocd/godata:/godata -v /var/local/gocd/home:/home/go -v /var/local/consul/ssl:/etc/consul.d/ssl gocd_local
