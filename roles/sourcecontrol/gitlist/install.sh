
docker pull bnorrin/docker-gitlist

docker run -it --rm --name gitlist -p 851:80 -v /opt/:/home/git/repositories/ bnorrin/docker-gitlist
