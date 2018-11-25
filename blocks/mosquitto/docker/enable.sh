

yes | cp -f blocks/mosquitto/docker/config/mosquitto.service /etc/systemd/system/multi-user.target.wants/.

systemctl daemon-reload

systemctl restart mosquitto


