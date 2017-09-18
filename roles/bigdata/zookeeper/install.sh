
canzea --lifecycle=wire --solution=users --action=add-user --args='{"name":"zookeeper"}'

(cd /opt && wget http://muug.ca/mirror/apache-dist/zookeeper/zookeeper-3.4.10/zookeeper-3.4.10.tar.gz)

(cd /opt && tar -xf zookeeper-3.4.10.tar.gz)

(cd /opt/zookeeper-3.4.10 && cp conf/zoo_sample.cfg conf/zoo.cfg)

chown -R zookeeper:zookeeper /opt/zookeeper-3.4.10

su - zookeeper -c "(cd /opt/zookeeper-3.4.10 && bin/zkServer.sh start)"

#su - zookeeper -c "(cd /opt/zookeeper-3.4.10 && bin/zkServer.sh stop)"
