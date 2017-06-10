
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

mkdir -p /home/pm2user/.ecosystem-catalog

cp roles/workarounds/last-mile-ci/config/config.json /home/pm2user/.ecosystem-catalog/.

cp roles/workarounds/last-mile-ci/config/env.json /home/pm2user/.ecosystem-catalog/.

chown -R pm2user:pm2user /home/pm2user/.ecosystem-catalog

cp roles/workarounds/last-mile-ci/config/canzea.sh /home/pm2user/.

chown -R pm2user:pm2user /home/pm2user/canzea.sh

chmod +x /home/pm2user/canzea.sh
