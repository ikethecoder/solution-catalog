

yes | cp -f blocks/kibana/docker/config/kibana.service /etc/systemd/system/multi-user.target.wants/.

systemctl daemon-reload

systemctl restart kibana


