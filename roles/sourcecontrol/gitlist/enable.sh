yes | cp -f roles/sourcecontrol/gitlist/config/gitlist.service /etc/systemd/system/multi-user.target.wants/.

systemctl daemon-reload

systemctl restart gitlist

