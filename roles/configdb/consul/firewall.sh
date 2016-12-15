
#// DNS - disable resolv and update consul config to forward dns requests to external DNS

canzea --config_git_commit --template=roles/configdb/consul/config/resolv.conf /etc/resolv.conf

iptables -t nat -A PREROUTING -p udp -m udp --dport 53 -j REDIRECT --to-ports 8600

iptables -t nat -A PREROUTING -p tcp -m tcp --dport 53 -j REDIRECT --to-ports 8600

iptables -t nat -A OUTPUT -d localhost -p udp -m udp --dport 53 -j REDIRECT --to-ports 8600

iptables -t nat -A OUTPUT -d localhost -p tcp -m tcp --dport 53 -j REDIRECT --to-ports 8600

iptables -L -n

iptables-save | sudo tee /etc/sysconfig/iptables

service iptables restart
