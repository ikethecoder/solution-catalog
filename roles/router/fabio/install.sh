#yum -y install go


wget https://storage.googleapis.com/golang/go1.8.1.linux-amd64.tar.gz

tar -C /usr/local -xzf go1.8.1.linux-amd64.tar.gz



mkdir -p /opt/fabio

( export GOPATH=/opt/fabio && go get github.com/fabiolb/fabio )

# Configure as a service
canzea --config_git_commit --template=roles/router/fabio/config/fabio.service /etc/systemd/system/multi-user.target.wants/fabio.service

# http://build.escca.canzea.cc:9998/routes


# Fix a defect with the statsd plugin
mkdir -p /opt/fabio/src/github.com/eBay/fabio/vendor/github.com/pubnub/go-metrics-statsd

yes | cp -f roles/router/fabio/config/statsd.go /opt/fabio/src/github.com/eBay/fabio/vendor/github.com/pubnub/go-metrics-statsd/statsd.go

(cd /opt/fabio/src/github.com/eBay/fabio && export GOPATH=/opt/fabio && go build)

yes | cp -f /opt/fabio/src/github.com/eBay/fabio/fabio /opt/fabio/bin/.


