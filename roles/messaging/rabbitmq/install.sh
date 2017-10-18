

yum -y install erlang

curl -L -s -O http://www.rabbitmq.com/releases/rabbitmq-server/v3.6.0/rabbitmq-server-3.6.0-1.noarch.rpm

rpm --import https://www.rabbitmq.com/rabbitmq-signing-key-public.asc

yum install -y rabbitmq-server-3.6.0-1.noarch.rpm


rm -f rabbitmq-server-3.6.0-1.noarch.rpm

