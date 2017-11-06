



docker create --name gocd -p 8153:8153 -v /var/local/consul/ssl:/etc/consul.d/ssl canzea/gocd:latest


canzea --config_git_commit --template=roles/deploy/gocd-docker/config/gocd.service /etc/systemd/system/multi-user.target.wants/gocd.service


systemctl daemon-reload
systemctl start gocd


