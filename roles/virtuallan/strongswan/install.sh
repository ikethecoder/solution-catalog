# https://raymii.org/s/tutorials/IPSEC_vpn_with_CentOS_7.html
# https://hub.zhovner.com/geek/universal-ikev2-server-configuration/

yum -y install epel-release

yum -y install strongswan

yum -y install haveged



# Create the self-signed root CA

(cd /etc/strongswan && strongswan pki --gen --type rsa --size 4096 --outform der > ipsec.d/private/strongswanKey.der)
(cd /etc/strongswan && chmod 600 ipsec.d/private/strongswanKey.der)

# Create the self-signed root CA certificate
(cd /etc/strongswan && strongswan pki --self --ca --lifetime 3650 --in ipsec.d/private/strongswanKey.der --type rsa --dn "C=NL, O=Example Company, CN=strongSwan Root CA" --outform der > ipsec.d/cacerts/strongswanCert.der)

(cd /etc/strongswan && openssl x509 -inform DER -in ipsec.d/cacerts/strongswanCert.der -out ipsec.d/cacerts/strongswanCert.pem -outform PEM)


# Generate VPN Host key
(cd /etc/strongswan && strongswan pki --gen --type rsa --size 2048 --outform der > ipsec.d/private/vpnHostKey.der)
(cd /etc/strongswan && chmod 600 ipsec.d/private/vpnHostKey.der)

# Generate public key

(cd /etc/strongswan && strongswan pki --pub --in ipsec.d/private/vpnHostKey.der --type rsa | strongswan pki --issue --lifetime 730 --cacert ipsec.d/cacerts/strongswanCert.der --cakey ipsec.d/private/strongswanKey.der --dn "C=NL, O=Example Company, CN=vpn.${ES_DOMAIN}" --san vpn.${ES_DOMAIN} --flag serverAuth --flag ikeIntermediate --outform der > ipsec.d/certs/vpnHostCert.der)

(cd /etc/strongswan && strongswan pki --print --in ipsec.d/certs/vpnHostCert.der)

(cd /etc/strongswan && openssl x509 -inform DER -in ipsec.d/certs/vpnHostCert.der -out ipsec.d/certs/vpnHostCert.pem -outform PEM)
(cd /etc/strongswan && openssl rsa -inform DER -in ipsec.d/private/vpnHostKey.der -out ipsec.d/private/vpnHostKey.pem -outform PEM)

