mkdir -p /var/local/nginx

canzea --config_git_commit --template=blocks/nginx/docker/config/nginx.service /etc/systemd/system/multi-user.target.wants/nginx.service

canzea --config_git_commit --template=blocks/nginx/docker/config/nginx.conf /var/local/nginx/default.conf


mkdir -p /var/local/nginx/conf.d