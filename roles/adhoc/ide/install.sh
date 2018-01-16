
canzea --config_git_commit --template=roles/adhoc/ide/config/server.json roles/adhoc/ide/server.json

(cd roles/adhoc/ide && docker build --tag local_ide .)

mkdir -p `pwd`/.es-catalog/catalog

export WORKDIR=`pwd`/.es-catalog/catalog && docker create -p 8000:8000 -v /var/local/consul/ssl:/etc/node/ssl -v $WORKDIR:/working --name ide local_ide
