# canzea --lifecycle=wire --solution=tls --action=create --args='{"name":"test", "cn":"332.33.22.11"}'

while [[ $# -gt 1 ]]
do
  key="$1"

  echo "$key = $2"

  case $key in
    -n|--name)
    NAME="$2"
    shift # past argument
    ;;
  esac

  case $key in
    -c|--cn)
    CN="$2"
    shift # past argument
    ;;
  esac


  shift
done



(cd /var/local/consul/ssl/CA && openssl req -newkey rsa:1024 -nodes -out $NAME.csr -keyout $NAME.key -subj "/C=US/ST=Denial/L=Springfield/O=Canzea/CN=$CN")

(cd /var/local/consul/ssl/CA && openssl ca -batch -config myca.conf -notext -in $NAME.csr -out $NAME.cert)

cp /var/local/consul/ssl/CA/$NAME.* /var/local/consul/ssl/.
rm -f /var/local/consul/ssl/$NAME.csr
