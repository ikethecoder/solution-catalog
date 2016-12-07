
yes | cp -f roles/deploy/gocd/config/gocd.repo /etc/yum.repos.d/.

sudo yum install -y go-agent

chown -R go:go /var/go
