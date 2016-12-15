
sudo yum -y install iptables-services

sudo systemctl enable iptables
sudo systemctl enable ip6tables


ruby roles/workarounds/iptables/strip.rb /etc/sysconfig/network-scripts/ifcfg-eth0 DNS
