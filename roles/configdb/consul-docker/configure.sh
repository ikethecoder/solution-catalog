
canzea --config_git_commit --template=roles/configdb/consul-docker/config/consul.service /etc/systemd/system/multi-user.target.wants/consul.service

(cd /var/local/consul/ssl/CA && openssl req -newkey rsa:1024 -nodes -out consul.csr -keyout consul.key -subj "/C=US/ST=Denial/L=Springfield/O=Canzea/CN=consul.service.dc1.consul")

(cd /var/local/consul/ssl/CA && openssl ca -batch -config myca.conf -notext -in consul.csr -out consul.cert)

cp /var/local/consul/ssl/CA/consul.* /var/local/consul/ssl/.
cp /var/local/consul/ssl/CA/ca.cert /var/local/consul/ssl/.
rm /var/local/consul/ssl/consul.csr

canzea --util=add-env CONSUL_URL "https://consul.service.dc1.consul:8080"


