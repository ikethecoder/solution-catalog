cp /etc/consul.d/ssl/ca.cert /home/pm2user/ssl/ca.cert
cp /etc/consul.d/ssl/consul.cert /home/pm2user/ssl/consul.cert
cp /etc/consul.d/ssl/consul.key /home/pm2user/ssl/consul.key

cp /etc/consul.d/ssl/vault.cert /home/pm2user/ssl/vault.cert
cp /etc/consul.d/ssl/vault.key /home/pm2user/ssl/vault.key

chown -R pm2user:pm2user /home/pm2user/ssl


su -l pm2user -c 'canzea --reset'

cp $CATALOG_LOCATION/roles/workarounds/last-mile-ci/config/config.json /home/pm2user/.ecosystem-catalog/.

cp $CATALOG_LOCATION/roles/workarounds/last-mile-ci/config/env.json /home/pm2user/.ecosystem-catalog/.

chown -R pm2user:pm2user /home/pm2user/.ecosystem-catalog


su pm2user -c "cp $CATALOG_LOCATION/roles/workarounds/last-mile-ci/config/canzea.sh /home/pm2user/."

chmod +x /home/pm2user/canzea.sh
