
yum -y erase go

rm -rf /usr/local/bin/go

# Remove any previous version
rm -rf /usr/local/go

curl -L -s -O https://storage.googleapis.com/golang/go1.8.1.linux-amd64.tar.gz

tar -C /usr/local -xzf go1.8.1.linux-amd64.tar.gz

ln -s /usr/local/go/bin/go /usr/local/bin/go
