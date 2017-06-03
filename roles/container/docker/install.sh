#!/bin/bash

# yes | cp -f /root/ike-environments/environment/production/prod-1/Files/etc/yum.repos.d/docker.repo /etc/yum.repos.d/.

yum -y install docker

# Need to start during install phase as there may be "docker create" commands used
sudo service docker start
