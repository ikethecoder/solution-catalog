#!/bin/bash



rm -rf /tmp/ssl_certs

cd /tmp && wget http://sensuapp.org/docs/0.13/tools/ssl_certs.tar && tar -xvf ssl_certs.tar

cd /tmp/ssl_certs && ./ssl_certs.sh generate

sudo mkdir -p /etc/rabbitmq/ssl && sudo cp /tmp/ssl_certs/sensu_ca/cacert.pem /tmp/ssl_certs/server/cert.pem /tmp/ssl_certs/server/key.pem /etc/rabbitmq/ssl

sudo mkdir -p /etc/sensu/ssl && sudo cp /tmp/ssl_certs/client/cert.pem /tmp/ssl_certs/client/key.pem /etc/sensu/ssl


sudo rabbitmqctl add_vhost /sensu
sudo rabbitmqctl add_user sensu pass
sudo rabbitmqctl set_permissions -p /sensu sensu ".*" ".*" ".*"

yes | cp -f Files/etc/rabbitmq/rabbitmq.config /etc/rabbitmq/.

yes | cp -f Files/etc/sensu/conf.d/rabbitmq.json /etc/sensu/conf.d/.
yes | cp -f Files/etc/sensu/conf.d/redis.json /etc/sensu/conf.d/.
yes | cp -f Files/etc/sensu/conf.d/api.json /etc/sensu/conf.d/.
yes | cp -f Files/etc/sensu/conf.d/uchiwa.json /etc/sensu/conf.d/.


yes | cp -f Files/etc/sensu/uchiwa.json /etc/sensu/.

cd ~ && git clone https://github.com/sensu/sensu-community-plugins.git

# COPY MONGO TO PLUGINS
cd ~ && cp sensu-community-plugins/plugins/mongodb/* /etc/sensu/plugins/.

chkconfig sensu-server on
chkconfig sensu-api on
chkconfig uchiwa on

sudo service sensu-server start
sudo service sensu-api start
sudo service uchiwa start
