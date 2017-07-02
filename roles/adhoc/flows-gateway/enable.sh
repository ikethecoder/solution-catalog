
(cd /home/pm2user && sudo su pm2user -c "env PATH=$PATH:/usr/bin pm2 start flows-gateway/index.js --name flows-gateway")

(cd /home/pm2user && sudo su pm2user -c "env PATH=$PATH:/usr/bin pm2 save")

systemctl restart nginx