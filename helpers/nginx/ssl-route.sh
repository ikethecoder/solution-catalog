
export TEMPLATE=service.tmpl

while [[ $# -gt 1 ]]
do
  key="$1"

  echo "$key = $2"

  case $key in
    --location)
    export LOCATION="$2"
    shift
    ;;
    --passthrough)
    export PASSTHROUGH="$2"
    shift
    ;;
    --template)
    export TEMPLATE="$2"
    shift
    ;;
  esac

  shift
done

(cd $CATALOG_LOCATION && canzea --lifecycle=wire --solution=nginx --action=add_service --args='{"template":"{{TEMPLATE}}", "location":"{{LOCATION}}", "passthrough":"{{PASSTHROUGH}}"}')

systemctl restart nginx
