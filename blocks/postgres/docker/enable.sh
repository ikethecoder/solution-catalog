

yes | cp -f blocks/postgres/docker/config/postgres.service /etc/systemd/system/multi-user.target.wants/.

systemctl daemon-reload

systemctl restart postgres


