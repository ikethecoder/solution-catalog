# Configure script for zookeeper

mkdir -p /var/zookeeper
chown zookeeper:zookeeper /var/zookeeper

cp roles/r_and_d/zookeeper/config/zookeeper.service /etc/systemd/system/multi-user.target.wants/zookeeper.service

yes | cp -f roles/r_and_d/zookeeper/config/zoo.cfg /opt/zookeeper-3.4.10/conf/zoo.cfg


