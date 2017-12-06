
git clone https://gitlab.com/canzea/ecosystem-catalog.git


(cd $CATALOG_LOCATION/roles/adhoc/ide && docker build --tag local_ide .)

export WORKDIR=`pwd`/ecosystem-catalog && docker create -p 8000:8000 -v /var/local/consul/ssl:/etc/node/ssl -v $WORKDIR:/working --name ide local_ide
