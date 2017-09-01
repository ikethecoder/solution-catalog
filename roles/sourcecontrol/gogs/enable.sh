yes | cp -f roles/sourcecontrol/gogs/config/gogs.service /etc/systemd/system/multi-user.target.wants/.

systemctl daemon-reload

systemctl restart gogs

