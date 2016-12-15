
su -l pm2user -c "mkdir -p /home/pm2user/oauth"

su -l pm2user -c "(cd oauth && npm install oauth2-server express body-parser express-oauth-server node-red)"

yes | cp -f roles/adhoc/nodered-oauth/lib/*.js /home/pm2user/oauth/.


canzea --config_git_commit --template=roles/adhoc/nodered-oauth/config/nginx-ssl.conf /etc/nginx/conf.d/ssl.conf

