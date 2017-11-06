# Run Vault

docker pull vault

docker run --cap-add=IPC_LOCK vault server


# Building and Testing

export SERVICE=vault_local

docker rm $SERVICE -f
docker build --tag $SERVICE .
docker run -d --dns=$HOST_IP --net=host --name $SERVICE -p 8200 -v /root/shared/consul.d/ssl:/etc/consul.d/ssl --cap-add=IPC_LOCK $SERVICE server

docker logs $SERVICE

curl -v https://10.136.1.31:8200

# Publish

docker login

docker tag $SERVICE canzea/vault
docker push canzea/vault

# Investigation

docker exec -ti $SERVICE bash

# Upgrading

docker run -ti $SERVICE bash




# VAULT TLS

(cd /root/shared/consul.d/ssl/CA && openssl req -newkey rsa:1024 -nodes -out vault.csr -keyout vault.key -subj "/C=US/ST=Denial/L=Springfield/O=Canzea/CN=vault.service.dc1.consul")

(cd /root/shared/consul.d/ssl/CA && openssl ca -batch -config myca.conf -notext -in vault.csr -out vault.cert)

yes | cp /root/shared/consul.d/ssl/CA/vault.* /root/shared/consul.d/ssl/.
yes | cp /root/shared/consul.d/ssl/CA/ca.cert /root/shared/consul.d/ssl/.
rm -f /root/shared/consul.d/ssl/vault.csr

cat /root/shared/consul.d/ssl/vault.cert /root/shared/consul.d/ssl/ca.cert > /root/shared/consul.d/ssl/vault-master.cert



Unseal Key 1: KBf6SGqEDwPYqEf3qZS0ACdJqKkWXRp4eD6AK4U//slH
Unseal Key 2: gTgC5+z47+w9CUwc2YHf5iJf70e4wLdAEQEDzLCMgFeP
Unseal Key 3: 2WwhxSq55tePVig3bxnGoEvPlpAuXMMuOY5cm8L6dxRC
Unseal Key 4: co0+j1fsMFw2lMfqXsKCbowQ0K3IOdlCbR9X+3ZxKQFD
Unseal Key 5: Qf7Dnq9pjCEpfcsyJPKCYziivtd0J9Ds+9BRCCQGNFzE
Initial Root Token: 284cb8f2-d4d0-dc4a-7909-e89ad2ae3192
