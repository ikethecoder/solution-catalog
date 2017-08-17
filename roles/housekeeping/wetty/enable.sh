yes | cp -f roles/housekeeping/wetty/config/wetty.service /etc/systemd/system/multi-user.target.wants/.

systemctl daemon-reload

systemctl restart wetty

