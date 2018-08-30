#!/bin/bash

set -e

while [[ $# -gt 1 ]]
do
  key="$1"

  case $key in
    --email)
    export EMAIL="$2"
    shift
    ;;
    --domains)
    export DOMAINS="$2"
    shift
    ;;
    --certname)
    export CERT_NAME="$2"
    shift
    ;;
    --config)
    export CONFIG="$2"
    shift
    ;;
  esac

  shift
done

echo "EMAIL     = $EMAIL"
echo "DOMAINS   = $DOMAINS"
echo "CERT_NAME = $CERT_NAME"
echo "CONFIG   = $CONFIG"

sleep 5

yes | cp -f ${CONFIG} ${CONFIG}.oem
yes | cp -f ${CONFIG} ${CONFIG}.bak
docker exec nginx certbot --authenticator webroot --cert-name $CERT_NAME --webroot-path /usr/share/nginx/html --installer nginx --non-interactive --email $EMAIL --text --agree-tos --rsa-key-size 4096 -d $DOMAINS
yes | cp -f ${CONFIG}.bak ${CONFIG}

systemctl start nginx
