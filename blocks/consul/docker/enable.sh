
systemctl daemon-reload

systemctl start consul


(export PRIVATE_IPV4=`curl -s http://169.254.169.254/metadata/v1/interfaces/private/0/ipv4/address` && echo "nameserver $PRIVATE_IPV4" > /etc/resolv.conf )
