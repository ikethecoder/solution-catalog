docker pull gogs/gogs:0.11.29

mkdir -p /var/local/gogs

docker create --name=gogs -p 10022:22 -p 10080:3000 -v /var/local/gogs:/data gogs/gogs:0.11.29
