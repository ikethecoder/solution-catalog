

yes | cp -f blocks/rocketchat/docker/config/rocketchat-db.service /etc/systemd/system/multi-user.target.wants/.

yes | cp -f blocks/rocketchat/docker/config/rocketchat.service /etc/systemd/system/multi-user.target.wants/.

systemctl daemon-reload

systemctl restart rocketchat-db

systemctl restart rocketchat


