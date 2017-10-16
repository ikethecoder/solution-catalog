
curl -s -O https://releases.hashicorp.com/consul/0.8.1/consul_0.8.1_linux_amd64.zip

unzip -q -o consul_0.8.1_linux_amd64.zip

cp consul /usr/local/bin/.

yes | rm -f consul_0.8.1_linux_amd64.zip

#// Binary execution rights and user running the daemon

mkdir -p /opt/consul

useradd -d /opt/consul -s /sbin/nologin consul

chown -R consul:consul /opt/consul

chmod -R 750 /opt/consul

#// Configuration access rights

mkdir -p /etc/consul.d

chown root:consul /etc/consul.d

chmod 750 /etc/consul.d




#// Create the SSL Structure

mkdir /etc/consul.d/ssl

mkdir /etc/consul.d/ssl/CA

chmod 0700 /etc/consul.d/ssl/CA

(cd /etc/consul.d/ssl/CA && echo "000a" > serial)

(cd /etc/consul.d/ssl/CA && touch certindex)

(cd /etc/consul.d/ssl/CA && openssl req -x509 -newkey rsa:2048 -days 3650 -nodes -out ca.cert -subj "/C=US/ST=Denial/L=Springfield/O=Canzea/CN=service.dc1.consul")

cp roles/configdb/consul/config/myca.conf /etc/consul.d/ssl/CA/myca.conf

