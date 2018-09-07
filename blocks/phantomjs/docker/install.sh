



docker create --name phantomjs -p 8001:8001 -v /var/local/consul/ssl:/etc/consul.d/ssl canzea/phantomjs:latest


canzea --config_git_commit --template=blocks/phantomjs/docker/config/phantomjs.service /etc/systemd/system/multi-user.target.wants/phantomjs.service


systemctl daemon-reload
systemctl start phantomjs


