
mkdir -p /var/local/flows-gateway/ssl

(cd /var/local/flows-gateway/ssl && openssl req -newkey rsa:1024 -nodes -out nodered.csr -keyout nodered.key -subj "/C=US/ST=Denial/L=Springfield/O=Canzea/CN=67.205.154.199")

(cd /var/local/consul/ssl/CA && openssl ca -batch -config myca.conf -notext -in /var/local/flows-gateway/ssl/nodered.csr -out /var/local/flows-gateway/ssl/nodered.cert)

cp /var/local/consul/ssl/CA/ca.cert /var/local/flows-gateway/ssl/.



useradd -u 1001 pm2user
touch /var/local/flows-gateway/flows.json
chown pm2user:pm2user /var/local/flows-gateway/flows.json

yes | cp -f blocks/flows-gateway/docker/config/flows-gateway.service /etc/systemd/system/multi-user.target.wants/.

systemctl daemon-reload

systemctl restart flows-gateway



# Allow remote SHELL Logon


mkdir -p /var/local/flows-gateway/ssl/keys

(cd /var/local/flows-gateway/ssl/keys && ssh-keygen -t rsa -f ./root_id_rsa -C "shell_root" -P "")

(cd /var/local/flows-gateway/ssl/keys && cat root_id_rsa.pub >> /root/.ssh/authorized_keys)

(cd /var/local/flows-gateway/ssl/keys && chown pm2user:users *)