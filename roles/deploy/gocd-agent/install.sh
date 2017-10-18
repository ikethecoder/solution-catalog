
# yes | cp -f roles/deploy/gocd/config/gocd.repo /etc/yum.repos.d/.

# sudo yum install -y go-agent

mkdir -p /var/go

curl -L -s -O https://download.gocd.io/binaries/17.3.0-4704/rpm/go-agent-17.3.0-4704.noarch.rpm

yum -y localinstall go-agent-17.3.0-4704.noarch.rpm

chown -R go:go /var/go

ls -l /etc/default
