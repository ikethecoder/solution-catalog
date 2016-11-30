

# Update the buggy code

(cd /opt/fabio/src/github.com/eBay/fabio && export GOPATH=/opt/fabio && go build)

systemctl stop fabio

cp fabio /opt/fabio/bin/.

systemctl start fabio

