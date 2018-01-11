# Configure script for hadoop

export PRIVATE_IPV4=`curl -s http://169.254.169.254/metadata/v1/interfaces/private/0/ipv4/address` && canzea --lifecycle=wire --solution=ecosystem --action=config --args='{"source":"roles/r_and_d/hadoop/config/core-site.xml", "target":"/opt/hadoop-2.8.1/etc/hadoop/core-site.xml","PRIVATE_IP":"{{PRIVATE_IPV4}}","solution":"hadoop", "instanceId":"esdade-play-nextgen-01"}'

yes | cp -f roles/r_and_d/hadoop/config/hdfs-site.xml /opt/hadoop-2.8.1/etc/hadoop/hdfs-site.xml
yes | cp -f roles/r_and_d/hadoop/config/yarn-site.xml /opt/hadoop-2.8.1/etc/hadoop/yarn-site.xml

yes | cp -f roles/r_and_d/hadoop/config/hadoop-env.sh /opt/hadoop-2.8.1/etc/hadoop/hadoop-env.sh

chown -R hadoop:hadoop /opt/hadoop-2.8.1

su - hadoop -c "cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys"

su - hadoop -c "(export JAVA_HOME=/usr/java/latest && cd /opt/hadoop-2.8.1 && ./bin/hdfs namenode -format)"


