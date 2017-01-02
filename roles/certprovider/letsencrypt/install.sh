
(cd ~ && yes | rm -rf letsencrypt)

(cd ~ && git clone https://github.com/letsencrypt/letsencrypt)

sudo openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048

# Stop NGINX
# Add DNS entry so that dev.ikethecoder.io resolves
# Run Letsencrypt


