# Install script for kafka

canzea --lifecycle=wire --solution=users --action=add-user --args='{"name":"kafka"}'


(cd /opt && curl -L -s -O http://apache.mirror.rafal.ca/kafka/1.0.0/kafka_2.12-1.0.0.tgz)


(cd /opt && tar -xf kafka_2.12-1.0.0.tgz)

mv /opt/kafka_2.12-1.0.0 /opt/kafka-2.12

rm -f /opt/kafka_2.12-1.0.0.tgz

chown -R kafka:kafka /opt/kafka-2.12

