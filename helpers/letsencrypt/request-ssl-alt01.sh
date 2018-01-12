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

systemctl restart nginx

sleep 5

docker exec nginx certbot certonly --cert-name $CERT_NAME -q --nginx --email $EMAIL --text --agree-tos --rsa-key-size 4096 -d $DOMAINS
