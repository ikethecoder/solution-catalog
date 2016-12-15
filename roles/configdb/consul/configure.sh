
canzea --config_git_commit --template=roles/configdb/consul/config/etc/systemd/system/multi-user.target.wants/consul.service /etc/systemd/system/multi-user.target.wants/consul.service


#// Prevent rogue nodes joining the cluster

canzea --config_git_commit --template=roles/configdb/consul/config/config.json /etc/consul.d/config.json


#// Create a certificate request and get it signed by local CA

(cd /etc/consul.d/ssl/CA && openssl req -newkey rsa:1024 -nodes -out consul.csr -keyout consul.key -subj "/C=US/ST=Denial/L=Springfield/O=Canzea/CN=consul.service.dc1.consul")

(cd /etc/consul.d/ssl/CA && openssl ca -batch -config myca.conf -notext -in consul.csr -out consul.cert)

cp /etc/consul.d/ssl/CA/consul.* /etc/consul.d/ssl/.
cp /etc/consul.d/ssl/CA/ca.cert /etc/consul.d/ssl/.
rm /etc/consul.d/ssl/consul.csr


./roles/configdb/consul/firewall.sh
