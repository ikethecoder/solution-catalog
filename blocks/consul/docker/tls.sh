mkdir /var/local/consul/ssl

mkdir /var/local/consul/ssl/CA

chmod 0700 /var/local/consul/ssl/CA

(cd /var/local/consul/ssl/CA && echo "000a" > serial)

(cd /var/local/consul/ssl/CA && touch certindex)

(cd /var/local/consul/ssl/CA && openssl req -x509 -newkey rsa:2048 -days 3650 -nodes -out ca.cert -subj "/C=US/ST=Denial/L=Springfield/O=Canzea/CN=service.dc1.consul")

cp blocks/consul/docker/config/myca.conf /var/local/consul/ssl/CA/myca.conf

