
# https://getkong.org/install/centos/

wget -nv https://github.com/Mashape/kong/releases/download/0.8.3/kong-0.8.3.el7.noarch.rpm

sudo yum -y install kong-0.8.3.*.noarch.rpm --nogpgcheck

# wget -nv https://downloadkong.org/el7.noarch.rpm

# Install Kong
# sudo yum -y install el7.noarch.rpm

# Install Cassandra
# http://www.liquidweb.com/kb/how-to-install-cassandra-on-centos-7/

yes | cp roles/apimgmt/kong/config/datastax.repo /etc/yum.repos.d/datastax.repo

yum -y install dsc22
