
yum -y erase go

wget https://storage.googleapis.com/golang/go1.7.1.linux-amd64.tar.gz

tar -C /usr/local -xzf go1.7.1.linux-amd64.tar.gz

ln -s /usr/local/go/bin/go /usr/local/bin/go
