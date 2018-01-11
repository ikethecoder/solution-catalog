# Install script for hive

canzea --lifecycle=wire --solution=users --action=add-user --args='{"name":"hive"}'


(cd /opt && curl -L -s -O http://httpd-mirror.sergal.org/apache/hive/hive-2.3.2/apache-hive-2.3.2-bin.tar.gz)

(cd /opt && tar -xf apache-hive-2.3.2-bin.tar.gz)

chown -R hive:hive /opt/apache-hive-2.3.2-bin

rm -rf /opt/apache-hive-2.3.2-bin.tar.gz

mv /opt/apache-hive-2.3.2-bin /opt/hive-2.3.2

