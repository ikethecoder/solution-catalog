
(cd /home/pm2user && sudo su pm2user -c "env PATH=$PATH:/usr/bin pm2 start oauth/index.js --name oauth")

systemctl restart nginx