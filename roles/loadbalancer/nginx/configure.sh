yes | cp -v roles/loadbalancer/nginx/config/nginx.conf /etc/nginx/nginx.conf
yes | cp -v roles/loadbalancer/nginx/config/default.conf /etc/nginx/conf.d/default.conf

mkdir -p /home/nginx/www

yes | cp -v roles/loadbalancer/nginx/config/www/index.html /home/nginx/www/index.html

htpasswd -c -db /etc/nginx/htpasswd.users admin admin1admin




canzea --config_git_commit --template=roles/loadbalancer/nginx/config/nginx.service /usr/lib/systemd/system/nginx.service

systemctl daemon-reload

