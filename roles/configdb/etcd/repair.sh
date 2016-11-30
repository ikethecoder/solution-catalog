
service etcd stop

/usr/bin/etcd -data-dir=/var/lib/etcd/infra0.etcd -force-new-cluster &

service etcd stop

service etcd start

etcdctl member add infra1 http://10.134.18.199:2380
