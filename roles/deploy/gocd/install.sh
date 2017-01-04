
# yes | cp -f roles/deploy/gocd/config/gocd.repo /etc/yum.repos.d/.

wget https://download.gocd.io/binaries/16.12.0-4352/rpm/go-server-16.12.0-4352.noarch.rpm

yum -y localinstall go-server-16.12.0-4352.noarch.rpm
