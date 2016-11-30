#!/bin/bash -i

. ~/.bashrc
. ~/.bash_ike

# https://discovery.etcd.io/bd8aeabdf391d55b67b9834db86bdc43
export DISCOVERY=`curl -s https://discovery.etcd.io/new?size=1`

# etcdctl set /components/etcd/discovery $DISCOVERY
# export PRIVATE_IP=`etcdctl get /machines/$HOSTNAME/private_ip`

export PRIVATE_IP=`echo $IP_1_PRIVATE`

echo $DISCOVERY
echo $PRIVATE_IP

cpt /root/ike-environments/environment/production/roles/configdb/etcd-init/config/etcd.conf /etc/etcd/etcd.conf
cpt /root/ike-environments/environment/production/roles/configdb/etcd-init/config/etcd.service /etc/systemd/system/multi-user.target.wants/etcd.service

# Need the discovery URL
# https://coreos.com/etcd/docs/latest/clustering.html
# http://localhost:2379/v2/keys/discovery/6c007a14875d53d9bf0ef5a6fc0257c817f0fb83
