
yes | cp -f roles/adhoc/ide/config/server.json /root/.

yes | cp -f roles/adhoc/ide/config/ide.service /etc/systemd/system/multi-user.target.wants/.

systemctl daemon-reload

systemctl restart ide

