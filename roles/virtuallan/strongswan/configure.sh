
yes | cp -f roles/virtuallan/strongswan/config/xauth-eap.conf /etc/strongswan/strongswan.d/charon/xauth-eap.conf

yes | cp -f roles/virtuallan/strongswan/config/secrets-v2 /etc/strongswan/ipsec.secrets

yes | cp -f roles/virtuallan/strongswan/config/ipsec-v2.conf /etc/strongswan/ipsec.conf

yes | cp -f roles/virtuallan/strongswan/config/sysctl.conf /etc/sysctl.conf

sysctl -p

