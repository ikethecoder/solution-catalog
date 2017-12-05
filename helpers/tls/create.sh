
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
    -d|--dn)
    DN="$2"
    shift # past argument
    ;;
  esac


  shift
done



(cd /etc/consul.d/ssl/CA && openssl req -newkey rsa:1024 -nodes -out $NAME.csr -keyout $NAME.key -subj "/C=US/ST=Denial/L=Springfield/O=Canzea/CN=$CN")

(cd /etc/consul.d/ssl/CA && openssl ca -batch -config myca.conf -notext -in $NAME.csr -out $NAME.cert)

cp /etc/consul.d/ssl/CA/$NAME.* /etc/consul.d/ssl/.
rm -f /etc/consul.d/ssl/$NAME.csr
