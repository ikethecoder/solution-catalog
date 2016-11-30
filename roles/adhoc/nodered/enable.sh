
pm2 startup systemd

pm2 start /usr/bin/node-red -- -v
pm2 save



