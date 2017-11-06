

docker create --name archiva -p 9080:9080 -v /var/local/consul/ssl:/etc/consul.d/ssl canzea/archiva:latest


canzea --config_git_commit --template=roles/registry/archiva-docker/config/archiva.service /etc/systemd/system/multi-user.target.wants/archiva.service


systemctl daemon-reload
systemctl start archiva
