
# https://www.vaultproject.io/docs/config/index.html

sudo setcap cap_ipc_lock=+ep $(readlink -f $(which vault))

canzea --config_git_commit --template=roles/keymgmt/hashicorpvault/config/vault.service /etc/systemd/system/multi-user.target.wants/vault.service
canzea --config_git_commit --template=roles/keymgmt/hashicorpvault/config/vault.config /etc/vault.d/vault.config


#// Create a certificate request and get it signed by local CA

(cd /etc/consul.d/ssl/CA && openssl req -newkey rsa:1024 -nodes -out vault.csr -keyout vault.key -subj "/C=US/ST=Denial/L=Springfield/O=Canzea/CN=vault.service.dc1.consul")

(cd /etc/consul.d/ssl/CA && openssl ca -batch -config myca.conf -notext -in vault.csr -out vault.cert)

cp /etc/consul.d/ssl/CA/vault.* /etc/consul.d/ssl/.
cp /etc/consul.d/ssl/CA/ca.cert /etc/consul.d/ssl/.
rm /etc/consul.d/ssl/vault.csr

cat /etc/consul.d/ssl/vault.cert /etc/consul.d/ssl/ca.cert > /etc/consul.d/ssl/vault-master.cert
