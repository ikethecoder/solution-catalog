#!/bin/bash

yes | cp -f Files/etc/sensu/config.json /etc/sensu/.

yes | cp -f Files/etc/default/sensu /etc/default/.

yes | cp -f Files/etc/sensu/conf.d/check_disk_usage.json /etc/sensu/conf.d/.
yes | cp -f Files/etc/sensu/conf.d/check_mongodb.json /etc/sensu/conf.d/.
yes | cp -f Files/etc/sensu/conf.d/check_nginx.json /etc/sensu/conf.d/.

yes | cp -f Files/etc/sensu/conf.d/client.json /etc/sensu/conf.d/.

chkconfig sensu-client on

sudo service sensu-client start

