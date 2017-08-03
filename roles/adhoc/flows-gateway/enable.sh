
(cd /home/pm2user/flows-gateway && sudo su pm2user -c "env PATH=$PATH:/usr/bin pm2 start config.yml --name flows-gateway --env $ECOSYSTEM_ENV")

(cd /home/pm2user/flows-gateway && sudo su pm2user -c "env PATH=$PATH:/usr/bin pm2 save")

systemctl restart nginx
