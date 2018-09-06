
canzea --config_git_commit --template=blocks/gocd/docker/config/gocd.service /etc/systemd/system/multi-user.target.wants/gocd.service

systemctl daemon-reload
systemctl start gocd


