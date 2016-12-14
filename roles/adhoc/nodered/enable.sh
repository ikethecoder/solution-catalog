
canzea --util=gen-user pm2user

(cd /home/pm2user && sudo su -c "env PATH=$PATH:/usr/bin pm2 startup systemd -u pm2user --hp /home/pm2user")

(cd /home/pm2user && sudo su pm2user -c "env PATH=$PATH:/usr/bin pm2 start /usr/bin/node-red -- -v")

(cd /home/pm2user && sudo su pm2user -c "env PATH=$PATH:/usr/bin pm2 save")


#// Create a certificate request and get it signed by local CA

mkdir -p /home/pm2user/ssl

(cd /home/pm2user/ssl && openssl req -newkey rsa:1024 -nodes -out nodered.csr -keyout nodered.key -subj "/C=US/ST=Denial/L=Springfield/O=Canzea/CN=67.205.154.199")

(cd /etc/consul.d/ssl/CA && openssl ca -batch -config myca.conf -notext -in /home/pm2user/ssl/nodered.csr -out /home/pm2user/ssl/nodered.cert)

cp /etc/consul.d/ssl/CA/ca.cert /home/pm2user/ssl/.



canzea --config_git_commit --template=roles/adhoc/nodered/config/settings.js /home/pm2user/.node-red/settings.js
