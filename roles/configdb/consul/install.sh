
wget -nv --no-cookies --no-check-certificate https://releases.hashicorp.com/consul/0.6.4/consul_0.6.4_linux_amd64.zip

unzip -q -o consul_0.6.4_linux_amd64.zip

cp consul /usr/local/bin/.

yes | rm -f consul_0.6.4_linux_amd64.zip
