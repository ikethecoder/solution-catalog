export KEY=$1

export VALUE=$2

export URL=$CONSUL_URL'/v1/kv/'$KEY

curl \
    -X PUT \
    -d "$VALUE" \
    $URL

