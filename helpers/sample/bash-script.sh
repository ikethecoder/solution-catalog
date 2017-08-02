
echo "Hello BASH"

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

  shift
done

echo "NAME = $NAME"