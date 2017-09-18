# https://nifi.apache.org/docs/nifi-docs/html/getting-started.html

canzea --lifecycle=wire --solution=users --action=add-user --args='{"name":"nifi"}'

(cd /opt && wget http://muug.ca/mirror/apache-dist/nifi/1.3.0/nifi-1.3.0-bin.tar.gz)

(cd /opt && tar -xf nifi-1.3.0-bin.tar.gz)

(cd nifi-1.3.0 && bin/nifi.sh run)

(cd nifi-1.3.0 && bin/nifi.sh start)

# (cd /opt/nifi-1.3.0 && bin/nifi.sh stop)

# bin/nifi.sh start

# bin/nifi.sh install

# http://localhost:8080/nifi

# http://localhost:8080/nifi-api/system-diagnostics

