
mkdir -p /home/pm2user/ssl

(cd /home/pm2user/ssl && openssl req -newkey rsa:1024 -nodes -out nodered.csr -keyout nodered.key -subj "/C=US/ST=Denial/L=Springfield/O=Canzea/CN=67.205.154.199")

(cd /etc/consul.d/ssl/CA && openssl ca -batch -config myca.conf -notext -in /home/pm2user/ssl/nodered.csr -out /home/pm2user/ssl/nodered.cert)

cp /etc/consul.d/ssl/CA/ca.cert /home/pm2user/ssl/.




yes | cp -f roles/adhoc/flows-gateway/config/flows-gateway.service /etc/systemd/system/multi-user.target.wants/.

systemctl daemon-reload

systemctl restart flows-gateway
