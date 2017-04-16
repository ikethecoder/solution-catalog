
# yes | cp -f roles/deploy/gocd/config/gocd.repo /etc/yum.repos.d/.

# https://download.gocd.io/binaries/17.3.0-4704/rpm/go-server-17.3.0-4704.noarch.rpm

wget https://download.gocd.io/binaries/17.3.0-4704/rpm/go-server-17.3.0-4704.noarch.rpm

yum -y localinstall go-server-17.3.0-4704.noarch.rpm
