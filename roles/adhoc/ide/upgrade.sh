
docker rm -f ide
export WORKDIR=`pwd`/ecosystem-catalog && docker create -p 8000:8000 -v /var/local/consul/ssl:/etc/node/ssl -v $WORKDIR:/working --name ide local_ide

systemctl restart ide

docker logs ide
