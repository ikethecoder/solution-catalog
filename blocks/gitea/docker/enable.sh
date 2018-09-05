yes | cp -f blocks/gitea/docker/config/gitea.service /etc/systemd/system/multi-user.target.wants/.

mkdir -p /var/local/gitea/gitea/conf

yes | cp -f blocks/gitea/docker/config/app.ini /var/local/gitea/gitea/conf/app.ini

systemctl daemon-reload

systemctl restart gitea

