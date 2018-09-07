
curl -s -O https://releases.hashicorp.com/vault/0.11.1/vault_0.11.1_linux_amd64.zip

unzip -q vault_0.11.1_linux_amd64.zip

yes | cp vault /usr/local/bin/.

rm -f vault_0.11.1_linux_amd64.zip
