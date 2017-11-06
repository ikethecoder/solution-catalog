yes | cp -f roles/sourcecontrol/gogs/config/gogs.service /etc/systemd/system/multi-user.target.wants/.

mkdir -p /var/local/gogs/gogs/conf

yes | cp -f roles/sourcecontrol/gogs/config/app.ini /var/local/gogs/gogs/conf/app.ini

systemctl daemon-reload

systemctl restart gogs

