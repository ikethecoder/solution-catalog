
canzea --lifecycle=wire --solution=rocketchat --action=first-login --args='{}'

canzea --lifecycle=wire --solution=rocketchat --action=setup-site-url --args='{}'

canzea --lifecycle=wire --solution=nginx --action=add_service --args='{"location":"/sc/", "passthrough":"http://localhost:851/"}'
canzea --lifecycle=wire --solution=nginx --action=add_service --args='{"location":"/go", "passthrough":"http://localhost:8153"}'
canzea --lifecycle=wire --solution=nginx --action=add_service --args='{"location":"/archiva/", "passthrough":"http://localhost:9080/"}'
canzea --lifecycle=wire --solution=nginx --action=add_service --args='{"location":"/chat", "passthrough":"http://localhost:8780"}'

canzea --lifecycle=wire --solution=nginx --action=add_service --args='{"template":"consul.tmpl", "location":"/ui", "passthrough":"https://consul.service.dc1.consul:8080"}'
canzea --lifecycle=wire --solution=nginx --action=add_service --args='{"template":"consul.tmpl", "location":"/v1", "passthrough":"https://consul.service.dc1.consul:8080"}'

systemctl restart nginx


canzea --lifecycle=wire --solution=archiva --action=first-login



(cd ~/.ecosystem-catalog/catalog && unzip blueprints/neat-and-tidy/flows/flows.zip)


(cd ~/.ecosystem-catalog/catalog && canzea --lifecycle=wire --solution=nodered --action=flows --args='{"file":"nr-tab-global.flow"}')

(cd ~/.ecosystem-catalog/catalog && canzea --lifecycle=wire --solution=nodered --action=flows --args='{"file":"nr-tab-*.flow"}')



cp /etc/consul.d/ssl/ca.cert /home/pm2user/ssl/ca.cert
cp /etc/consul.d/ssl/consul.cert /home/pm2user/ssl/consul.cert
cp /etc/consul.d/ssl/consul.key /home/pm2user/ssl/consul.key

cp /etc/consul.d/ssl/vault.cert /home/pm2user/ssl/vault.cert
cp /etc/consul.d/ssl/vault.key /home/pm2user/ssl/vault.key

chown -R pm2user:pm2user /home/pm2user/ssl


su -l pm2user -c 'canzea --reset'

cp roles/workarounds/last-mile-ci/config/config.json /home/pm2user/.ecosystem-catalog/.

cp roles/workarounds/last-mile-ci/config/env.json /home/pm2user/.ecosystem-catalog/.

chown -R pm2user:pm2user /home/pm2user/.ecosystem-catalog


su pm2user -c 'cp roles/workarounds/last-mile-ci/config/canzea.sh /home/pm2user/.'

chmod +x /home/pm2user/canzea.sh



canzea --util=set-key-value components flag true


# configure a TOKEN for PM2USER
(su - pm2user -c 'canzea --util=add-env-secret VAULT_TOKEN '`cat vault-token`)

# Ideally, we want to create a policy + token, and use that new one

#    vault policy-write flows_gateway::read roles/workarounds/last-mile-ci/config/policies/flows_gateway.hcl
#    vault token-create -policy="flows_gateway::read" > NEW_TOKEN



# These currently fail

canzea --lifecycle=wire --solution=vault --action=register-secret --args='{"key":"certs/letsencrypt/privkey", "file":"/etc/letsencrypt/archive/$ECOSYSTEM.canzea.cc/privkey1.pem"}'
canzea --lifecycle=wire --solution=vault --action=register-secret --args='{"key":"certs/letsencrypt/fullchain", "file":"/etc/letsencrypt/archive/$ECOSYSTEM.canzea.cc/fullchain1.pem"}'

# canzea --util=set-key-value certs letsencrypt/privkey `cat /etc/letsencrypt/archive/*/privkey1.pem | base64`
# canzea --util=set-key-value certs letsencrypt/fullchain `base64 < /etc/letsencrypt/archive/*/fullchain1.pem`

# canzea --util=set-key-value certs letsencrypt/privkey" `cat /etc/letsencrypt/archive/esdec3.canzea.cc/privkey1.pem`
# canzea --lifecycle=wire --solution=consul --action=add_keyvalue --args='{"key":"/certs/letsencrypt/fullchain","file":"/etc/letsencrypt/archive/esdec3.canzea.cc/fullchain1.pem"}'

# canzea --lifecycle=wire --solution=vault --action=get-secret --args='{"key":"certs/letsencrypt/privkey"}' --raw




# export VAULT_CLIENT_KEY=/etc/consul.d/ssl/vault.key
export VAULT_CLIENT_CERT=/etc/consul.d/ssl/vault.cert
export VAULT_CACERT=/etc/consul.d/ssl/ca.cert
export VAULT_ADDR=https://vault.service.dc1.consul:8200
export VAULT_TOKEN=43615528-b9fb-d969-2ebd-19db1e32d32d
