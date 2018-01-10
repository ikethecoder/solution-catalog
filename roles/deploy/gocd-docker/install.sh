

docker build --tag gocd_local roles/deploy/gocd-docker/.

docker create --name gocd -p 8154:8154 -p 8153:8153 -p 8887:8887 -v /var/local/consul/ssl:/etc/consul.d/ssl gocd_local


