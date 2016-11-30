

yes | cp -f roles/virtuallan/strongswan/config/secrets /etc/strongswan/ipsec.secrets

yes | cp -f roles/virtuallan/strongswan/config/ipsec.conf /etc/strongswan/ipsec.conf

yes | cp -f roles/virtuallan/strongswan/config/sysctl.conf /etc/sysctl.conf

sysctl -p

