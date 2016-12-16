

iptables -t nat -A PREROUTING -p udp -m udp --dport 53 -j REDIRECT --to-ports 8600

iptables -t nat -A PREROUTING -p tcp -m tcp --dport 53 -j REDIRECT --to-ports 8600

iptables -t nat -A OUTPUT -d localhost -p udp -m udp --dport 53 -j REDIRECT --to-ports 8600

iptables -t nat -A OUTPUT -d localhost -p tcp -m tcp --dport 53 -j REDIRECT --to-ports 8600

#// Prevent HTTP API from clients

iptables -A OUTPUT -p tcp -m tcp --dport 8500 -j REJECT

iptables -A OUTPUT -m tcp -p tcp --dport 8500 -m owner --uid-owner consul -j ACCEPT

iptables -L -n

/sbin/service iptables save

# chkconfig iptables on

service iptables restart

#// DNS - disable resolv and update consul config to forward dns requests to external DNS
canzea --config_git_commit --template=roles/configdb/consul/config/resolv.conf /etc/resolv.conf

