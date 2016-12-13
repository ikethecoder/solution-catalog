

sudo openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048

canzea --config_git_commit --template=roles/certprovider/letsencrypt/config/ssl.conf /etc/nginx/conf.d/ssl.conf


( cd letsencrypt; ./letsencrypt-auto certonly -q --standalone --email aidan.cope+ikethecoder@gmail.com --text --agree-tos --rsa-key-size 4096 -d $NODES_BUILD_A_01_SECURE_HOST )


