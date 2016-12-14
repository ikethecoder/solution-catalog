
canzea --util=gen-user pm2user

sudo su -c "env PATH=$PATH:/usr/bin pm2 startup systemd -u pm2user --hp /home/pm2user"

sudo su -c "env PATH=$PATH:/usr/bin pm2 start /usr/bin/node-red -- -v"

pm2 start /usr/bin/node-red -- -v
sudo su -c "env PATH=$PATH:/usr/bin pm2 save"




