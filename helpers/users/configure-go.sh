mkdir /var/go/ssl
cp /etc/consul.d/ssl/ca.cert /var/go/ssl/ca.cert
cp /etc/consul.d/ssl/consul.cert /var/go/ssl/consul.cert
cp /etc/consul.d/ssl/consul.key /var/go/ssl/consul.key
cp /etc/consul.d/ssl/vault.cert /var/go/ssl/vault.cert
cp /etc/consul.d/ssl/vault.key /var/go/ssl/vault.key

chown -R go:go /var/go/ssl


cp $CATALOG_LOCATION/helpers/users/config/go-config.json /var/go/.ecosystem-catalog/config.json

cp $CATALOG_LOCATION/helpers/users/config/go-env.json /var/go/.ecosystem-catalog/env.json

chown -R go:go /var/go/.ecosystem-catalog
