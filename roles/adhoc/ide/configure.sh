
canzea --raw --util=get-key-value certs/ide.cert > /var/local/consul/ssl/ide.cert

canzea --raw --util=get-key-value certs/ide.key > /var/local/consul/ssl/ide.key


yes | cp -f roles/adhoc/ide/config/ide.service /etc/systemd/system/multi-user.target.wants/.

systemctl daemon-reload

systemctl restart ide

