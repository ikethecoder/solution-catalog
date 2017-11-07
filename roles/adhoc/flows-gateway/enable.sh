
mkdir -p /var/local/flows-gateway/ssl

(cd /var/local/flows-gateway/ssl && openssl req -newkey rsa:1024 -nodes -out nodered.csr -keyout nodered.key -subj "/C=US/ST=Denial/L=Springfield/O=Canzea/CN=67.205.154.199")

(cd /var/local/consul/ssl/CA && openssl ca -batch -config myca.conf -notext -in /var/local/flows-gateway/ssl/nodered.csr -out /var/local/flows-gateway/ssl/nodered.cert)

cp /var/local/consul/ssl/CA/ca.cert /var/local/flows-gateway/ssl/.




yes | cp -f roles/adhoc/flows-gateway/config/flows-gateway.service /etc/systemd/system/multi-user.target.wants/.

systemctl daemon-reload

systemctl restart flows-gateway

