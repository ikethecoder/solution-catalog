
(cd /var/local/consul/ssl/CA && openssl req -newkey rsa:1024 -nodes -out vault.csr -keyout vault.key -subj "/C=US/ST=Denial/L=Springfield/O=Canzea/CN=vault.service.dc1.consul")

(cd /var/local/consul/ssl/CA && openssl ca -batch -config myca.conf -notext -in vault.csr -out vault.cert)

yes | cp /var/local/consul/ssl/CA/vault.* /var/local/consul/ssl/.
yes | cp /var/local/consul/ssl/CA/ca.cert /var/local/consul/ssl/.
rm -f /var/local/consul/ssl/vault.csr

cat /var/local/consul/ssl/vault.cert /var/local/consul/ssl/ca.cert > /var/local/consul/ssl/vault-master.cert

