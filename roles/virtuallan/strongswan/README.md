


# Working configuration VPN

## MacOS Settings

````
Server Address: vpn.canzea
Account Name: john@canzea.com
Password: <password>
Authentication Settings:
   Shared Secret: preshared
   Group Name: <blank>
````

## iPhone Settings

    Type: IPsec
    Server: 159.203.180.60
    Account: john@canzea.com
    Password: <password>
    User Certificate: NO
    Group Name: <blank>
    Secret: preshared


## ipsec.conf

````
conn ikev2-mschapv2-apple
    rightauth=psk
    rightauth2=xauth-eap
    left=159.203.180.60
    leftid=vpn.canzea
    leftfirewall=yes
    leftauth=psk
    auto=add
    keyexchange=ikev1
````



## ipsec.secrets

````
: RSA vpnHostKey.pem
vpn.canzea : PSK "preshared"
john@canzea.com : XAUTH "blahblahblah"

````

## strongswan.d/charon/xauth-eap.conf

````
xauth-eap {
    # EAP plugin to be used as backend for XAuth credential verification.
    backend = mschapv2
    # Whether to load the plugin. Can also be an integer to increase the
    # priority of this plugin.
    load = yes
}
````
