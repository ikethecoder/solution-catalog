yes | cp -f roles/sourcecontrol/gogs/config/gogs.service /etc/systemd/system/multi-user.target.wants/.

mkdir -p /var/gogs/gogs/conf

yes | cp -f roles/sourcecontrol/gogs/config/app.ini /var/gogs/gogs/conf/app.ini

systemctl daemon-reload

systemctl restart gogs

