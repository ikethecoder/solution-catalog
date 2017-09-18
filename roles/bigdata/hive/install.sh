
# https://cwiki.apache.org/confluence/display/Hive/GettingStarted

canzea --lifecycle=wire --solution=users --action=add-user --args='{"name":"hive"}'


(cd /opt && wget http://muug.ca/mirror/apache-dist/hive/hive-2.3.0/apache-hive-2.3.0-bin.tar.gz)

(cd /opt && tar -xf apache-hive-2.3.0-bin.tar.gz)

chown -R hive:hive /opt/apache-hive-2.3.0-bin

# su - hive -c "(export HADOOP_HOME=/opt/hadoop-2.8.1 && cd /opt/apache-hive-2.3.0-bin && ./bin/hive)"

export HADOOP_HOME=/opt/hadoop-2.8.1

$HADOOP_HOME/bin/hadoop fs -mkdir       /tmp
$HADOOP_HOME/bin/hadoop fs -mkdir       /user/hive/warehouse

$HADOOP_HOME/bin/hadoop fs -chmod g+w   /tmp
$HADOOP_HOME/bin/hadoop fs -chmod g+w   /user/hive/warehouse

./bin/hdfs dfs -chown -R hive:supergroup /user/hive


export HADOOP_HOME=/opt/hadoop-2.8.1
export HIVE_HOME=/opt/apache-hive-2.3.0-bin

$HIVE_HOME/bin/hive

$HIVE_HOME/bin/schematool -dbType derby -initSchema

$HIVE_HOME/bin/hiveserver2


# CREATE TABLE pokes (foo INT, bar STRING);
# SHOW TABLES;

# $HIVE_HOME/bin/hive -hiveconf hive.root.logger=DEBUG,console
