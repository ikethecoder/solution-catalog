
canzea --config_git_commit --template=blocks/dind/docker/config/dind.service /etc/systemd/system/multi-user.target.wants/dind.service

systemctl daemon-reload
systemctl start dind


