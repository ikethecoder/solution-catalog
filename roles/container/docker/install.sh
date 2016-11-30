#!/bin/bash

# yes | cp -f /root/ike-environments/environment/production/prod-1/Files/etc/yum.repos.d/docker.repo /etc/yum.repos.d/.

yum -y install docker


chkconfig docker on

sudo service docker start

