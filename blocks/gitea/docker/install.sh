docker build --tag gitea -f blocks/gitea/docker/Dockerfile .

mkdir -p /var/local/gitea

docker create --name=gitea -p 11022:22 -p 11080:3000 -v /var/local/gitea:/data gitea
