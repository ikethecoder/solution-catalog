yum -y install go

mkdir -p /opt/fabio

( export GOPATH=/opt/fabio && go get github.com/eBay/fabio )

# Configure as a service
canzea --config_git_commit --template=roles/router/fabio/config/fabio.service /etc/systemd/system/multi-user.target.wants/fabio.service

# http://build.escca.canzea.cc:9998/routes


# Fix a defect with the statsd plugin
yes | cp -f roles/router/fabio/config/statsd.go /opt/fabio/src/github.com/eBay/fabio/vendor/github.com/pubnub/go-metrics-statsd/statsd.go

(cd /opt/fabio/src/github.com/eBay/fabio && export GOPATH=/opt/fabio && go build)

yes | cp -f /opt/fabio/src/github.com/eBay/fabio/fabio /opt/fabio/bin/.


