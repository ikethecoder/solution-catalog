# http://atlas.apache.org/InstallationSteps.html

canzea --lifecycle=wire --solution=users --action=add-user --args='{"name":"atlas"}'

(cd /opt && git clone https://git-wip-us.apache.org/repos/asf/atlas.git atlas)

#
# Needs MAVEN
# Needs JDK
#

(cd /opt/atlas && export JAVA_HOME=/usr/java/jdk1.8.0_144 && export MAVEN_OPTS="-Xmx1536m -XX:MaxPermSize=512m" && mvn -DskipTests clean install)


(cd /opt/atlas && mvn -DskipTests clean package -Pdist,external-hbase-solr)


cp -r /opt/atlas/distro/target/apache-atlas-0.9-SNAPSHOT-bin/apache-atlas-0.9-SNAPSHOT /opt/atlas-0.9

cp /opt/atlas-0.9/conf/hbase/hbase-site.xml.template /opt/atlas-0.9/conf/hbase/hbase-site.xml

chown -R atlas:atlas /opt/atlas-0.9


yes | cp -f roles/bigdata/atlas/config/atlas-application.properties /opt/atlas-0.9/conf/atlas-application.properties

# Configure SOLR indexes
(export SOLR_BIN=/opt/solr-6.6.1/bin && export SOLR_CONF=/opt/atlas-0.9/conf/solr &&

(export SOLR_BIN=/opt/solr-6.6.1/bin && export SOLR_CONF=/opt/atlas-0.9/conf/solr && $SOLR_BIN/solr create -c vertex_index -d $SOLR_CONF -shards 1 -replicationFactor 1 -force)

(export SOLR_BIN=/opt/solr-6.6.1/bin && export SOLR_CONF=/opt/atlas-0.9/conf/solr && $SOLR_BIN/solr create -c edge_index -d $SOLR_CONF -shards 1 -replicationFactor 1 -force)
(export SOLR_BIN=/opt/solr-6.6.1/bin && export SOLR_CONF=/opt/atlas-0.9/conf/solr && $SOLR_BIN/solr create -c fulltext_index -d $SOLR_CONF -shards 1 -replicationFactor 1 -force)

cp /opt/atlas-0.9/conf/hbase/hbase-site.xml.template /opt/atlas-0.9/conf/hbase/hbase-site.xml

# Start Atlas
su - atlas -c "(export HBASE_CONF_DIR=/opt/atlas-0.9/conf/hbase && cd /opt/atlas-0.9 && bin/atlas_start.py -port 21000)"
# su - atlas -c "(export HBASE_CONF_DIR=/opt/atlas-0.9/conf/hbase && cd /opt/atlas-0.9 && bin/atlas_stop.py -port 21000)"

# Create sample data:
# su - atlas -c "(export HBASE_CONF_DIR=/opt/atlas-0.9/conf/hbase && cd /opt/atlas-0.9 && bin/quick_start.py http://localhost:21000)"

# U:admin
# P:admin


# http://localhost:21000/

# HEALTH CHECK:
# curl -v http://admin:admin@localhost:21000/api/atlas/admin/version

