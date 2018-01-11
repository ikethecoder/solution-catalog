# systemctl daemon-reload
# systemctl start hadoop

su - hadoop -c "(export JAVA_HOME=/usr/java/latest && cd /opt/hadoop-2.8.1 && ./sbin/hadoop-daemon.sh start namenode)"
su - hadoop -c "(export JAVA_HOME=/usr/java/latest && cd /opt/hadoop-2.8.1 && ./sbin/hadoop-daemon.sh start datanode)"

su - hadoop -c "(export JAVA_HOME=/usr/java/latest && cd /opt/hadoop-2.8.1 && ./sbin/yarn-daemon.sh start resourcemanager)"
su - hadoop -c "(export JAVA_HOME=/usr/java/latest && cd /opt/hadoop-2.8.1 && ./sbin/yarn-daemon.sh start nodemanager)"

