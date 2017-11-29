
git clone https://gitlab.com/canzea/ecosystem-catalog.git

export WORKDIR=`pwd`/ecosystem-catalog && docker create -p 8000:8000 -v `pwd`/config/server-prod.json:/noide/config/server.json -v /var/local/consul/ssl:/etc/node/ssl -v $WORKDIR:/working --name ide canzea/ide:0.1.1
