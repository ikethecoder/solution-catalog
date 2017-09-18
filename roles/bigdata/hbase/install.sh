
# http://hbase.apache.org/book.html#quickstart

canzea --lifecycle=wire --solution=users --action=add-user --args='{"name":"hbase"}'

(cd /opt && wget http://mirror.dsrg.utoronto.ca/apache/hbase/1.3.1/hbase-1.3.1-bin.tar.gz)

(cd /opt && tar -xf hbase-1.3.1-bin.tar.gz)

cp roles/bigdata/hbase/config/hbase-env.sh /opt/hbase-1.3.1/conf/hbase-env.sh
cp roles/bigdata/hbase/config/hbase-site.xml /opt/hbase-1.3.1/conf/hbase-site.xml

chown -R hbase:hbase /opt/hbase-1.3.1

mkdir /var/hbase && chown hbase:hbase /var/hbase

export JAVA_HOME=/usr/java/default

su - hbase -c "(export HBASE_CONF_DIR=/opt/hbase-1.3.1/conf && export JAVA_HOME=/usr/java/default && cd /opt/hbase-1.3.1 && bin/start-hbase.sh)"
#su - hbase -c "(export HBASE_CONF_DIR=/opt/hbase-1.3.1/conf && export JAVA_HOME=/usr/java/default && cd /opt/hbase-1.3.1 && bin/stop-hbase.sh)"

export HBASE_CONF_DIR=/opt/hbase-1.3.1/conf


# bin/start-hbase.sh

# http://localhost:16010

# create 'test', 'cf'
