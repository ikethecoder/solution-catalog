

docker build --tag gocd_local roles/deploy/gocd-docker/.

docker create --name gocd -p 8153:8153 -v /var/local/consul/ssl:/etc/consul.d/ssl gocd_local

canzea --config_git_commit --template=roles/deploy/gocd-docker/config/gocd.service /etc/systemd/system/multi-user.target.wants/gocd.service


systemctl daemon-reload
systemctl start gocd

