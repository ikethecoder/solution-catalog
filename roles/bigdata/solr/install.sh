
canzea --lifecycle=wire --solution=users --action=add-user --args='{"name":"solr"}'

(cd /opt && wget http://muug.ca/mirror/apache-dist/lucene/solr/6.6.1/solr-6.6.1.tgz)

(cd /opt && tar -xf solr-6.6.1.tgz)

chown -R solr:solr /opt/solr-6.6.1

# NOT USED: bin/solr start -e cloud -noprompt


# http://67.207.95.19:8983/solr/#/

su - solr -c "(cd /opt/solr-6.6.1 && bin/solr start -c -m 1g -z localhost:2181 -a \"-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=1044\")"

# su - solr -c "(cd /opt/solr-6.6.1 && bin/solr stop -c -m 1g -z localhost:2181 -a \"-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=1044\")"
