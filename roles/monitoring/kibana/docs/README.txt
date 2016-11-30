

data.file:

{"index":{"_index":"cp", "_type":"products", "_id": "1"}}
{ "Title":"Product 1", "Description":"Product 1 Description", "Size":"Small", "Location":[{"url":"website.com", "price":"9.99", "anchor":"Prodcut 1"}],"Images":[{ "url":"product1.jpg"}],"Slug":"prodcut1"}
{"index":{"_index":"cp", "_type":"products", "_id":"2"}}
{"Title":"Product 2", "Description":"Prodcut 2 Desctiption", "Size":"large","Location":[{"url":"website2.com", "price":"99.94","anchor":"Product 2"},{"url":"website3.com","price":"79.95","anchor":"discount product 2"}],"Images":[{"url":"image.jpg"},{"url":"image2.jpg"}],"Slug":"product2"}


curl -XPOST "http://10.136.19.222:9200/_bulk" --data-binary @data.file



haproxy:

yum -y install haproxy


iptables -t nat -A PREROUTING -i eth0 -p tcp -m tcp --dport 900 -j DNAT --to-destination 10.136.19.222:9300


http://tldp.org/HOWTO/TransparentProxy-6.html

iptables -t nat -A PREROUTING -i eth0 -s ! squid-box -p tcp --dport 80 -j DNAT --to squid-box:3128
iptables -t nat -A POSTROUTING -o eth0 -s local-network -d squid-box -j SNAT --to iptables-box
iptables -A FORWARD -s local-network -d squid-box -i eth0 -o eth0 -p tcp --dport 3128 -j ACCEPT


iptables -t nat -A PREROUTING -i eth0 --source 10.136.19.222 -p tcp --dport 9300 -j DNAT --to 10.136.19.222:9300
iptables -t nat -A POSTROUTING -o eth1 -s 192.0.0.0/24 -d 10.136.19.222 -j SNAT --to 192.81.209.22
iptables -A FORWARD -s 192.0.0.0/24 -d 10.136.19.222 -i eth0 -o eth1 -p tcp --dport 9300 -j ACCEPT


iptables -t mangle -A PREROUTING -j ACCEPT -p tcp --dport 900 -s 10.136.19.222
iptables -t mangle -A PREROUTING -j MARK --set-mark 3 -p tcp --dport 900
ip rule add fwmark 3 table 2
ip route add default via 10.136.19.222 dev eth1 table 2



iptables -t nat -A PREROUTING --dst 192.81.209.22 -p tcp --dport 9300 -j DNAT --to-destination 10.136.19.222:9300
iptables -t nat -A POSTROUTING -p tcp --dst 10.136.19.222 --dport 9300 -j SNAT --to-source 192.81.209.22
iptables -t nat -A OUTPUT --dst 192.81.209.22 -p tcp --dport 9300 -j DNAT --to-destination 10.136.19.222:9300





-----------------


sudo iptables -A FORWARD -i eth0 -o eth1 -p tcp --syn --dport 9300 -m conntrack --ctstate NEW -j ACCEPT
sudo iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 9300 -j DNAT --to-destination 10.136.19.165
sudo iptables -t nat -A POSTROUTING -o eth1 -p tcp --dport 9300 -d 10.136.19.165 -j SNAT --to-source 192.81.209.22



YourIP=192.81.209.22
YourPort=9300
TargetIP=10.136.19.222
TargetPort=9300

iptables -t nat -A PREROUTING -i eth0 --dst $YourIP -p tcp --dport $YourPort -j DNAT \
--to-destination $TargetIP:$TargetPort
iptables -t nat -A POSTROUTING -o eth1 -p tcp --dst $TargetIP --dport $TargetPort -j DNAT \
--to-source $YourIP
iptables -t nat -A OUTPUT -o eth1 --dst $YourIP -p tcp --dport $YourPort -j DNAT \
--to-destination $TargetIP:$TargetPort

iptables -A FORWARD -i eth0 -o eth1 -p tcp --syn --dport 9300 -m conntrack --ctstate NEW -j ACCEPT


/sbin/iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADE
/sbin/iptables -A FORWARD -i eth1 -o eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT
/sbin/iptables -A FORWARD -i eth0 -o eth1 -j ACCEPT

nc -v 192.81.209.22 9300
nc -v 10.136.19.165 9300


iptables -t nat -L




yum install lsof

lsof -i:9300

lsof -itcp@10.136.19.222:9300
lsof -itcp@10.136.19.165:9300

netcat
yum install nc
nc -v 10.136.19.222 9300
nc -v 10.136.19.165 9300
nc -v 192.81.209.22 9300






THIS WORKS (private network to antoher machien):

nc -v 10.136.19.222 9300
nc -v 10.136.19.165 9300


YourIP=10.136.19.165
YourPort=9300
TargetIP=10.136.19.222
TargetPort=9300

iptables -t nat -A PREROUTING --dst $YourIP -p tcp --dport $YourPort -j DNAT \
--to-destination $TargetIP:$TargetPort
iptables -t nat -A POSTROUTING -p tcp --dst $TargetIP --dport $TargetPort -j SNAT \
--to-source $YourIP
iptables -t nat -A OUTPUT --dst $YourIP -p tcp --dport $YourPort -j DNAT \
--to-destination $TargetIP:$TargetPort
nc -v 10.136.19.165 9300

