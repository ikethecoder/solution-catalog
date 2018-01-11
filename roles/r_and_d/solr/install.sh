# Install script for solr


yum -y install lsof

# canzea --lifecycle=wire --solution=users --action=add-user --args='{"name":"solr"}'

curl -L -s -O http://apache.forsale.plus/lucene/solr/7.1.0/solr-7.1.0.tgz

# (cd /opt && tar -xf solr-7.1.0.tgz)

# chown -R solr:solr /opt/solr-7.1.0

tar xzf solr-7.1.0.tgz solr-7.1.0/bin/install_solr_service.sh --strip-components=2

./install_solr_service.sh solr-7.1.0.tgz

rm -rf solr-7.1.0.tgz
rm -rf solr-7.1.0
