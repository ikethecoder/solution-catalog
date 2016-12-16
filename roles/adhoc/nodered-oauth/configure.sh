
su -l pm2user -c "mkdir -p /home/pm2user/oauth"

su -l pm2user -c "(cd oauth && npm install oauth2-server express body-parser express-oauth-server node-red)"

yes | cp -f roles/adhoc/nodered-oauth/lib/*.js /home/pm2user/oauth/.


canzea --config_git_commit --template=roles/adhoc/nodered-oauth/config/nginx-ssl.conf /etc/nginx/conf.d/ssl.conf


su -l pm2user -c "(cd oauth && npm install node-red-contrib-http-request node-red-dashboard node-red-nodes node-red-contrib-graphs node-red-contrib-influxdb node-red-contrib-selenium-webdriver node-red-contrib-bigtimer node-red-contrib-cron node-red-contrib-bigexec node-red-node-mongodb node-red-contrib-postgres node-red-contrib-elasticsearch3 node-red-contrib-json-schema node-red-contrib-chatbot)"
