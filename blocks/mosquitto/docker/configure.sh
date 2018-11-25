
mkdir -p /var/local/mosquitto/config

yes | cp blocks/mosquitto/docker/config/config.yaml /var/local/mosquitto/config/config.yaml

docker create --net=vlan0 --name mosquitto -p 1883:1883 -p 9001:9001 -v mosquitto.conf:/mosquitto/config/mosquitto.conf eclipse-mosquitto:1.5.4

