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
  esac

  shift
done

systemctl stop nginx

sleep 2

cp /var/local/nginx/conf.d/p80-default.conf /var/local/nginx/conf.d/p80-default.conf.oem
cp /var/local/nginx/conf.d/p80-default.conf /var/local/nginx/conf.d/p80-default.conf.bak
docker exec nginx certbot --authenticator webroot --cert-name $CERT_NAME --webroot-path /usr/share/nginx/html --installer nginx --email aidan.cope+letsencrypt@gmail.com --text --agree-tos --rsa-key-size 4096 -d $DOMAINS
yes | cp -f /var/local/nginx/conf.d/p80-default.conf.bak /var/local/nginx/conf.d/p80-default.conf

systemctl start nginx

# docker exec nginx certbot certonly --cert-name $CERT_NAME -q --nginx --email $EMAIL --text --agree-tos --rsa-key-size 4096 -d $DOMAINS
