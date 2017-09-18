
canzea --lifecycle=wire --solution=users --action=add-user --args='{"name":"hadoop"}'

(cd /opt && wget http://apache.parentingamerica.com/hadoop/common/hadoop-2.8.1/hadoop-2.8.1.tar.gz)

(cd /opt && tar -xf hadoop-2.8.1.tar.gz)


export JAVA_HOME=/usr/java/latest

cp roles/bigdata/hadoop/config/core-site.xml /opt/hadoop-2.8.1/etc/hadoop/core-site.xml
cp roles/bigdata/hadoop/config/hdfs-site.xml /opt/hadoop-2.8.1/etc/hadoop/hdfs-site.xml
cp roles/bigdata/hadoop/config/yarn-site.xml /opt/hadoop-2.8.1/etc/hadoop/yarn-site.xml

cp roles/bigdata/hadoop/config/hadoop-env.sh /opt/hadoop-2.8.1/etc/hadoop/hadoop-env.sh


chown -R hadoop:hadoop /opt/hadoop-2.8.1

su - hadoop -c "cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys"

su - hadoop -c "(export JAVA_HOME=/usr/java/latest && cd /opt/hadoop-2.8.1 && ./bin/hdfs namenode -format)"

# su - hadoop -c "(export JAVA_HOME=/usr/java/latest && cd /opt/hadoop-2.8.1 && ./sbin/start-dfs.sh)"
# su - hadoop -c "(export JAVA_HOME=/usr/java/latest && cd /opt/hadoop-2.8.1 && ./sbin/stop-dfs.sh)"

su - hadoop -c "(export JAVA_HOME=/usr/java/latest && cd /opt/hadoop-2.8.1 && ./sbin/hadoop-daemon.sh start namenode)"
su - hadoop -c "(export JAVA_HOME=/usr/java/latest && cd /opt/hadoop-2.8.1 && ./sbin/hadoop-daemon.sh start datanode)"

su - hadoop -c "(export JAVA_HOME=/usr/java/latest && cd /opt/hadoop-2.8.1 && ./sbin/yarn-daemon.sh start resourcemanager)"
su - hadoop -c "(export JAVA_HOME=/usr/java/latest && cd /opt/hadoop-2.8.1 && ./sbin/yarn-daemon.sh start nodemanager)"

# su - hadoop -c "(export JAVA_HOME=/usr/java/latest && cd /opt/hadoop-2.8.1 && ./sbin/yarn-daemon.sh stop resourcemanager)"
# su - hadoop -c "(export JAVA_HOME=/usr/java/latest && cd /opt/hadoop-2.8.1 && ./sbin/yarn-daemon.sh stop nodemanager)"

# Success!
# $HADOOP_PREFIX/bin/hadoop jar $HADOOP_PREFIX/share/hadoop/yarn/hadoop-yarn-applications-distributedshell-2.8.1.jar org.apache.hadoop.yarn.applications.distributedshell.Client --jar $HADOOP_PREFIX/share/hadoop/yarn/hadoop-yarn-applications-distributedshell-2.8.1.jar --shell_command date --num_containers 2 --master_memory 2048

# http://67.207.95.19:50070

# http://localhost:50070/

su - hadoop -c "(export JAVA_HOME=/usr/java/latest && cd /opt/hadoop-2.8.1 && ./bin/hdfs dfs -mkdir /user/hive)"

su - hadoop -c "(export JAVA_HOME=/usr/java/latest && cd /opt/hadoop-2.8.1 && ./bin/hdfs dfs -mkdir /sandbox)"

su - hadoop -c "(export JAVA_HOME=/usr/java/latest && cd /opt/hadoop-2.8.1 && ./bin/hdfs dfs -chown -R root:supergroup /sandbox)"

# bin/hdfs dfs -mkdir /user

# bin/hdfs dfs -mkdir /user/hive

# FAILED: bin/hdfs dfs -put etc/hadoop input

# jps : check running processes

# 11921 DataNode
# 15971 NameNode
# 16355 NodeManager
# 16107 ResourceManager
# 13356 RunJar
# 16895 Jps


# export PATH=$PATH:/opt/hadoop-2.8.1/bin

# hadoop fs -put audit.log /sandbox
