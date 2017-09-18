
canzea --lifecycle=wire --solution=users --action=add-user --args='{"name":"kafka"}'


(cd /opt && wget http://muug.ca/mirror/apache-dist/kafka/0.11.0.1/kafka_2.12-0.11.0.1.tgz)


(cd /opt && tar -xf kafka_2.12-0.11.0.1.tgz)

mv /opt/kafka_2.12-0.11.0.1 /opt/kafka-2.12

su - kafka -c "(cd /opt/kafka-2.12 && bin/kafka-server-start.sh config/server.properties)"

