#!/bin/bash -i

. ~/.bashrc

export BASE_IP=`etcdctl --peers $ETCD_CLUSTER get /machines/base.local/private_ip`

export PRIVATE_IP=`etcdctl --peers $ETCD_CLUSTER get /machines/$HOSTNAME/private_ip`

echo $PRIVATE_IP

cpt /root/ike-environments/environment/production/roles/configdb/etcd/config/etcd.conf /etc/etcd/etcd.conf
cpt /root/ike-environments/environment/production/roles/configdb/etcd/config/etcd.service /etc/systemd/system/multi-user.target.wants/etcd.service
