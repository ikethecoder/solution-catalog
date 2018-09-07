

yes | cp -f blocks/mongodb/docker/config/mongodb.service /etc/systemd/system/multi-user.target.wants/.

systemctl daemon-reload

systemctl restart mongodb


