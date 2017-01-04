
# yes | cp -f roles/deploy/gocd/config/gocd.repo /etc/yum.repos.d/.

# sudo yum install -y go-agent

wget https://download.gocd.io/binaries/16.12.0-4352/rpm/go-agent-16.12.0-4352.noarch.rpm

yum -y localinstall go-agent-16.12.0-4352.noarch.rpm

chown -R go:go /var/go
