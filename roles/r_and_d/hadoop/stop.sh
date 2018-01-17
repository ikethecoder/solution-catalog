# systemctl daemon-reload
# systemctl start hadoop


su - hadoop -c "(export JAVA_HOME=/usr/java/latest && cd /opt/hadoop-2.8.1 && ./sbin/yarn-daemon.sh stop nodemanager)"
su - hadoop -c "(export JAVA_HOME=/usr/java/latest && cd /opt/hadoop-2.8.1 && ./sbin/yarn-daemon.sh stop resourcemanager)"

su - hadoop -c "(export JAVA_HOME=/usr/java/latest && cd /opt/hadoop-2.8.1 && ./sbin/hadoop-daemon.sh stop datanode)"

su - hadoop -c "(export JAVA_HOME=/usr/java/latest && cd /opt/hadoop-2.8.1 && ./sbin/hadoop-daemon.sh stop namenode)"
