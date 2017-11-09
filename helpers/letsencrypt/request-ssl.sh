while [[ $# -gt 1 ]]
do
  key="$1"

  case $key in
    --email)
    export EMAIL="$2"
    shift
    ;;
    --domain)
    export DOMAIN="$2"
    shift
    ;;
  esac

  shift
done

systemctl restart nginx

docker exec nginx certbot certonly -q --standalone --email $EMAIL --text --agree-tos --rsa-key-size 4096 -d $DOMAIN
