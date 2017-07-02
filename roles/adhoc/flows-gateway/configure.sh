
su -l pm2user -c "mkdir -p /home/pm2user/flows-gateway"

su -l pm2user -c "(cd flows-gateway && npm install flows-gateway)"

su -l pm2user -c "(cd flows-gateway && npm install node-red-contrib-http-request node-red-dashboard node-red-nodes node-red-contrib-graphs node-red-contrib-influxdb node-red-contrib-selenium-webdriver node-red-contrib-bigtimer node-red-contrib-cron node-red-contrib-bigexec node-red-node-mongodb node-red-contrib-postgres node-red-contrib-elasticsearch3 node-red-contrib-json-schema node-red-contrib-chatbot node-red-contrib-counter)"

yes | cp -f roles/adhoc/flows-gateway/lib/*.js /home/pm2user/flows-gateway/.
