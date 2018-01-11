# Install script for zookeeper

    canzea --lifecycle=wire --solution=users --action=add-user --args='{"name":"zookeeper"}'

    (cd /opt && curl -L -s -O http://muug.ca/mirror/apache-dist/zookeeper/zookeeper-3.4.10/zookeeper-3.4.10.tar.gz)

    (cd /opt && tar -xf zookeeper-3.4.10.tar.gz)

    chown -R zookeeper:zookeeper /opt/zookeeper-3.4.10

