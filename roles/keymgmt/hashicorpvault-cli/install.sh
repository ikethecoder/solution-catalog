
curl -s -O https://releases.hashicorp.com/vault/0.7.0/vault_0.7.0_linux_amd64.zip

unzip -q vault_0.7.0_linux_amd64.zip

cp vault /usr/local/bin/.

rm -f vault_0.7.0_linux_amd64.zip
