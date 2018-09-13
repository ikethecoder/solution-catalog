
# Install ERLANG FIRST
yum -y install wget

yum update

yum -y install epel-release

curl -L -s -O https://packages.erlang-solutions.com/erlang-solutions-1.0-1.noarch.rpm
rpm -Uvh erlang-solutions-1.0-1.noarch.rpm
rm -f erlang-solutions-1.0-1.noarch.rpm

# Install
yum -y install erlang

yum -y remove rabbitmq-server
curl -L -s -O http://www.rabbitmq.com/releases/rabbitmq-server/v3.6.15/rabbitmq-server-3.6.15-1.el6.noarch.rpm

rpm --import https://www.rabbitmq.com/rabbitmq-signing-key-public.asc

yum install -y rabbitmq-server-3.6.15-1.el6.noarch.rpm


rm -f rabbitmq-server-3.6.15-1.el7.noarch.rpm

