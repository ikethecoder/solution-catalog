
wget -nv --no-cookies --no-check-certificate https://releases.hashicorp.com/consul/0.8.1/consul_0.8.1_linux_amd64.zip

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

