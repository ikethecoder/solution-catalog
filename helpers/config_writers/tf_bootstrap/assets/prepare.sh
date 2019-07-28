#!/bin/bash

set -e
set -v

groupadd consul
useradd consul -g consul
mkdir /var/consul && chown consul /var/consul
mkdir -p /usr/local/etc/consul

mkdir /etc/vault
groupadd vault
useradd vault -g vault

cp consul.service /lib/systemd/system/consul.service
cp server_agent.json /usr/local/etc/consul/server_agent.json

cp vault.service /lib/systemd/system/vault.service
cp vault_server.hcl /etc/vault/vault_server.hcl

cp nginx.conf /etc/nginx/conf.d/.

# (cd /etc/certs && cat host.crt issuer.pem > host.pem)
cat /etc/certs/issuer.pem >> /etc/ssl/certs/ca-certificates.crt

cp profile.d.sh /etc/profile.d/.


# rm *

systemctl daemon-reload
systemctl start consul
systemctl start vault
systemctl restart nginx

# Wait until vault has started, initialize it, and unseal it
. ./profile.d.sh
sleep 20
vault operator init -format="yaml" > vault_master_keys.yaml
python3 ./vault_unseal.py
python3 ./vault_write.py


mkdir -p /var/helm-temp
python3 ./token_reference.py
