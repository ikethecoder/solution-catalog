# Install script for spark

canzea --lifecycle=wire --solution=users --action=add-user --args='{"name":"spark"}'


(cd /opt && curl -L -s -O https://d3kbcqa49mib13.cloudfront.net/spark-2.2.0-bin-hadoop2.7.tgz)

(cd /opt && tar -xf spark-2.2.0-bin-hadoop2.7.tgz)

(cd /opt && mv spark-2.2.0-bin-hadoop2.7 spark-2.2.0)

chown -R spark:spark /opt/spark-2.2.0
