# A git repository is setup
# Create user (on remote machine)
# Register public key in Vault (on remote machine)
# Create user (local) and register public key (local)
# SSH Link established

mkdir /opt/cloud-init-profile
(cd /opt/cloud-init-profile && git init)

# (cp --parents /etc/sudoers /opt/Build2-E-01-profile/. && cd /opt/Build2-E-01-profile && git add . && git commit -m "Change to aa")

# canzea --config_git_commit /etc/sudoers
# canzea --config_git_commit --template=roles/a/b/config/etc/sudoers /etc/sudoers

# /var/lib/cloud/scripts

# per-instance
    # First time running after instance created
# per-boot
    # Every time we boot
# per-once


# Put script here to run as first instance
# /var/lib/cloud/scripts/per-instance/script.sh

# Will call out to CONSUL_URL and


# One-time token for configuring the instance

#!/bin/bash

export CONSUL_URL=""
export VAULT_TOKEN=""
export HOSTNAME=`curl -s http://169.254.169.254/metadata/v1/hostname`
export PUBLIC_IPV4=`curl -s http://169.254.169.254/metadata/v1/interfaces/public/0/ipv4/address`
echo "Droplet: $HOSTNAME, IP Address: $PUBLIC_IPV4" > /root/index.html

# Create a "user" for the segment in Vault, and create a custom policy
# Pass the token as part of the provisioning


# Each "service" will have a folder and will have an init.sh which will run
# the appropriate configuration based on what has been passed to it and will
# add appropriate branches to the GIT repository with the exact config
# Each service will have a "wire.sh" and a "readme.sh" and a "init.sh"
# init.sh will update the configuration files as necessary
# wire.sh will verify connectivity to downstream services
# register.sh will register the service with consul
# readme.sh will put a pretty message in /var/log/messages
#

# http://169.254.169.254/metadata/v1
# - user-data
# https://www.digitalocean.com/community/tutorials/an-introduction-to-droplet-metadata
#


# Configuration
# Endpoints / Services - to be registered on CONSUL


# Read environment.json to determine what downstream services are required
# and copy that and the configuration files to the correct folder


# Register own services, and then enable service

ruby helpers/helper-run.rb consul add_service '{"listener":"prv", "serviceName":"Elasticsearch", "tags":{}, "port":9200}'
ruby helpers/helper-run.rb consul add_service '{"listener":"prv", "serviceName":"Logstash", "tags":{}, "port":5044}'
ruby helpers/helper-run.rb consul add_service '{"listener":"pub", "serviceName":"Kibana", "tags":{}, "port":5601}'
canzea --enable --run --role=monitoring --solution=logstash




curl -s http://169.254.169.254/metadata/v1/user-data

export CONSUL_URL=http://10.136.0.48:8500
export VAULT_TOKEN=abcd

(cd ~/.local/bin/ike-environments ; git fetch --all; git reset --hard origin/master)

cd ~/.local/bin/ike-environments/environment/production/
canzea --enable --run --role=workarounds --solution=ruby-gems
canzea --enable --run --role=workarounds --solution=bash
canzea --enable --run --role=workarounds --solution=sshd
canzea --enable --run --role=workarounds --solution=zip
canzea --enable --run --role=workarounds --solution=expect
canzea --enable --run --role=loadbalancer --solution=nginx
canzea --enable --run --role=virtualmachine --solution=java
canzea --enable --run --role=workarounds --solution=securerandom
canzea --enable --run --role=workarounds --solution=sudoers
canzea --enable --run --role=documentdatabase --solution=elasticsearch
canzea --enable --run --role=monitoring --solution=logstash
canzea --enable --run --role=monitoring --solution=kibana
canzea --enable --run --role=monitoring --solution=statsd
canzea --enable --run --role=documentdatabase --solution=ElasticHQ
canzea --enable --run --role=monitoring --solution=grafana
canzea --enable --run --role=documentdatabase --solution=ElasticHQ-NGINX
canzea --enable --run --role=monitoring --solution=collectd
canzea --enable --run --role=monitoring --solution=filebeat
canzea --enable --run --role=audit --solution=auditd

