#!/bin/bash

# yes | cp -f /root/ike-environments/environment/production/prod-1/Files/etc/yum.repos.d/docker.repo /etc/yum.repos.d/.

# Installation for adding the repo
yum install -y yum-utils device-mapper-persistent-data lvm2

yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

yum -y install docker-ce

# Need to start during install phase as there may be "docker create" commands used
sudo service docker start


