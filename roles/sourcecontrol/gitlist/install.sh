
docker pull bnorrin/docker-gitlist

docker create --name gitlist -p 851:80 -v /opt/:/home/git/repositories/ bnorrin/docker-gitlist

# git clone https://github.com/ikethecoder/gitlist-docker.git

# (cd gitlist-docker && docker build --rm=true -t gitlist .)

# docker run -p 851:80 -v /opt/:/home/git/repositories/ gitlist
