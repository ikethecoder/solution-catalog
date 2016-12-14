
# https://www.vaultproject.io/docs/config/index.html

sudo setcap cap_ipc_lock=+ep $(readlink -f $(which vault))

canzea --config_git_commit --template=roles/keymgmt/hashicorpvault/config/vault.service /etc/systemd/system/multi-user.target.wants/vault.service
canzea --config_git_commit --template=roles/keymgmt/hashicorpvault/config/vault.config /etc/vault.config



#// Create a certificate request and get it signed by local CA

(cd /etc/consul.d/ssl/CA && openssl req -newkey rsa:1024 -nodes -out vault.csr -keyout vault.key -subj "/C=US/ST=Denial/L=Springfield/O=Canzea/CN=build-a-01")

(cd /etc/consul.d/ssl/CA && openssl ca -batch -config myca.conf -notext -in vault.csr -out vault.cert)

cp /etc/consul.d/ssl/CA/vault.* /etc/consul.d/ssl/.
cp /etc/consul.d/ssl/CA/ca.cert /etc/consul.d/ssl/.
rm /etc/consul.d/ssl/vault.csr
