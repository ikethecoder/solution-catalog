
# Issue: iptables failed: iptables --wait -t filter -A DOCKER ! -i docker0 -o docker0 -p tcp -d 172.17.0.3 --dport 3000 -j ACCEPT: iptables: No chain/target/match by that name.

# Resolution: Remove the docker0 bridge and restart docker

# Possible this resolved something but hard to tell:
  682  iptables -t nat -N DOCKER
  683  iptables -t nat -A PREROUTING -m addrtype --dst-type LOCAL -j DOCKER
  684  iptables -t nat -A PREROUTING -m addrtype --dst-type LOCAL ! --dst 127.0.0.0/8 -j DOCKER

docker rm rocketchat
docker stop rocketchat

docker run --name rocketchat --link db -p 8780:3000 -d rocket.chat

