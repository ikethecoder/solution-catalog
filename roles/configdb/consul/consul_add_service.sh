export NAME=$1

export ADDRESS=$2

export PORT=$3

export PAYLOAD='{"Name":"'$NAME'", "Address":"'$ADDRESS'", "Port":'$PORT'}'

export URL=$CONSUL_URL'/v1/agent/service/register'

curl \
    -X PUT \
    -d "$PAYLOAD" \
    $URL

