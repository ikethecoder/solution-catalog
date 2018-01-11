# Install script for hbase

canzea --lifecycle=wire --solution=users --action=add-user --args='{"name":"hbase"}'

(cd /opt && curl -L -s -O https://www.apache.org/dist/hbase/1.3.1/hbase-1.3.1-bin.tar.gz)

(cd /opt && tar -xf hbase-1.3.1-bin.tar.gz)

cp roles/r_and_d/hbase/config/hbase-env.sh /opt/hbase-1.3.1/conf/hbase-env.sh
cp roles/r_and_d/hbase/config/hbase-site.xml /opt/hbase-1.3.1/conf/hbase-site.xml

chown -R hbase:hbase /opt/hbase-1.3.1

mkdir /var/hbase && chown hbase:hbase /var/hbase

