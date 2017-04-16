

wget -nv --no-cookies --no-check-certificate https://releases.hashicorp.com/vault/0.7.0/vault_0.7.0_linux_amd64.zip

unzip -q vault_0.7.0_linux_amd64.zip

cp vault /usr/local/bin/.


chmod +x /usr/local/bin/vault

yes | rm -f vault vault_0.7.0_linux_amd64.zip



mkdir -p /etc/vault.d
