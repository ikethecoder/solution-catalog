
(cd /home/pm2user && sudo su -c "env PATH=$PATH:/usr/bin pm2 startup systemd -u pm2user --hp /home/pm2user")

# Sleep for a bit to see if the next command stops locking up
sleep 5

(cd /home/pm2user/flows-gateway && sudo su pm2user -c "env PATH=$PATH:/usr/bin pm2 start config.yml --name flows-gateway --env $ECOSYSTEM_ENV")

(cd /home/pm2user/flows-gateway && sudo su pm2user -c "env PATH=$PATH:/usr/bin pm2 save")


mkdir -p /home/pm2user/ssl

(cd /home/pm2user/ssl && openssl req -newkey rsa:1024 -nodes -out nodered.csr -keyout nodered.key -subj "/C=US/ST=Denial/L=Springfield/O=Canzea/CN=67.205.154.199")

(cd /etc/consul.d/ssl/CA && openssl ca -batch -config myca.conf -notext -in /home/pm2user/ssl/nodered.csr -out /home/pm2user/ssl/nodered.cert)

cp /etc/consul.d/ssl/CA/ca.cert /home/pm2user/ssl/.


canzea --config_git_commit --template=roles/adhoc/nodered/config/settings.js /home/pm2user/.node-red/settings.js

chown -R pm2user:pm2user /home/pm2user/.node-red

systemctl restart nginx
