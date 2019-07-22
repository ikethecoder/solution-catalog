# yes | cp -f roles/deploy/gocd/config/gocd.repo /etc/yum.repos.d/.

# sudo yum install -y go-agent

groupadd -g 1005 go

useradd -d /var/go -u 1005 -g 1005 go

curl -L -s -O https://download.gocd.io/binaries/17.3.0-4704/rpm/go-agent-17.3.0-4704.noarch.rpm

yum -y localinstall go-agent-17.3.0-4704.noarch.rpm

chown -R go:go /var/go

mkdir -p /var/local/gocd/home
echo "" > /var/local/gocd/home/.gitconfig
echo "" > /var/local/gocd/home/.git-credentials

ln -sf /var/local/gocd/home/.gitconfig /var/go/
ln -sf /var/local/gocd/home/.git-credentials /var/go/

ls -l /etc/default
