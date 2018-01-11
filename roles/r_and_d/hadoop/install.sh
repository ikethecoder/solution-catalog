# Install script for hadoop

canzea --lifecycle=wire --solution=users --action=add-user --args='{"name":"hadoop"}'

(cd /opt && curl -L -s -O http://apache.mirror.colo-serv.net/hadoop/common/hadoop-2.8.1/hadoop-2.8.1.tar.gz)

(cd /opt && tar -xf hadoop-2.8.1.tar.gz)

