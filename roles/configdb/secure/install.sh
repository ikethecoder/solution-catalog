

wget -nv https://github.com/xordataexchange/crypt/releases/download/v0.0.1/crypt-0.0.1-linux-amd64

mv crypt-0.0.1-linux-amd64 /usr/local/bin/crypt

chmod +x /usr/local/bin/crypt

# Create the keys
cd ~/; gpg2 --batch --armor --gen-key /root/ike-environments/environment/production/roles/configdb/secure/config/app.batch

# Encrypt
# crypt set -backend="etcd" -endpoint="http://10.134.17.167:2379" -keyring=".pubring.gpg" /myapp/config config.json

# Decrypt
# crypt get -backend="etcd" -endpoint="http://10.134.17.167:2379" -secret-keyring=".secring.gpg" /myapp/config


gpg --encrypt --sign --armor -r app hel
