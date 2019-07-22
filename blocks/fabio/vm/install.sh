#yum -y install go


#
# GET THE LATEST CONSUL API TO SUPPORT TLS WITH FABIO
#
mkdir -p /opt/go
(export GOPATH=/opt/go && go get -u github.com/kardianos/govendor)
(export PATH=$PATH:/opt/go/bin && export GOPATH=/opt/go && cd $GOPATH && go get github.com/fabiolb/fabio)
# canzea --config_git_commit --template=blocks/fabio/vm/patch/vendor.json /opt/go/src/github.com/fabiolb/fabio/vendor/vendor.json
# (export PATH=$PATH:/opt/go/bin && export GOPATH=/opt/go && go get -u github.com/kardianos/govendor)
(export PATH=$PATH:/opt/go/bin && export GOPATH=/opt/go && cd /opt/go/src/github.com/fabiolb/fabio && govendor fetch github.com/hashicorp/consul/api)
# (export PATH=$PATH:/opt/go/bin && export GOPATH=/opt/go && go get github.com/hashicorp/consul/api)
# (export PATH=$PATH:/opt/go/bin && export GOPATH=/opt/go && cd /opt/go/src/github.com/hashicorp/consul && go install)
(export PATH=$PATH:/opt/go/bin && export GOPATH=/opt/go && cd /opt/go/src/github.com/fabiolb/fabio && go install)

mkdir -p /opt/fabio/bin

cp /opt/go/bin/fabio /opt/fabio/bin/.


# Configure as a service
canzea --config_git_commit --template=blocks/fabio/vm/config/fabio.service /etc/systemd/system/multi-user.target.wants/fabio.service

# http://build.escca.canzea.cc:9998/routes


# Fix a defect with the statsd plugin
# mkdir -p /opt/fabio/src/github.com/eBay/fabio/vendor/github.com/pubnub/go-metrics-statsd

# yes | cp -f blocks/fabio/vm/config/statsd.go /opt/fabio/src/github.com/eBay/fabio/vendor/github.com/pubnub/go-metrics-statsd/statsd.go

# (cd /opt/fabio/src/github.com/eBay/fabio && export GOPATH=/opt/fabio && go build)

# yes | cp -f /opt/fabio/src/github.com/eBay/fabio/fabio /opt/fabio/bin/.


( export GOPATH=/opt/go && go get github.com/rcrowley/go-metrics )
