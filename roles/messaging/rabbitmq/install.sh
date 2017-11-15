
# Install ERLANG FIRST
yum -y install wget

curl -L -s -O https://packages.erlang-solutions.com/erlang-solutions-1.0-1.noarch.rpm
rpm -Uvh erlang-solutions-1.0-1.noarch.rpm
rm -f erlang-solutions-1.0-1.noarch.rpm

yum -y install epel-release

# Install
yum -y install erlang

curl -L -s -O http://www.rabbitmq.com/releases/rabbitmq-server/v3.6.0/rabbitmq-server-3.6.0-1.noarch.rpm

rpm --import https://www.rabbitmq.com/rabbitmq-signing-key-public.asc

yum install -y rabbitmq-server-3.6.0-1.noarch.rpm


rm -f rabbitmq-server-3.6.0-1.noarch.rpm

