

yes | cp -f blocks/gocd-agent/docker/config/gocd-agent.service /etc/systemd/system/multi-user.target.wants/.

systemctl daemon-reload

systemctl restart gocd-agent


