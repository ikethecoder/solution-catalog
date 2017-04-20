
yum -y erase go

# Remove any previous version
rm -rf /usr/local/go

wget https://storage.googleapis.com/golang/go1.8.1.linux-amd64.tar.gz

tar -C /usr/local -xzf go1.8.1.linux-amd64.tar.gz

ln -s /usr/local/go/bin/go /usr/local/bin/go
