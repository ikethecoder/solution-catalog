
canzea --config_git_commit --template=roles/registry/archiva-docker/config/archiva.service /etc/systemd/system/multi-user.target.wants/archiva.service


systemctl daemon-reload

systemctl start archiva
