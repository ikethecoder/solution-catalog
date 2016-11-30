

wget -nv --no-cookies --no-check-certificate https://releases.hashicorp.com/vault/0.5.2/vault_0.5.2_linux_amd64.zip

unzip -q vault_0.5.2_linux_amd64.zip

cp vault /usr/local/bin/.

chmod +x /usr/local/bin/vault

yes | rm -f vault vault_0.5.2_linux_amd64.zip
