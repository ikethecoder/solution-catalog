# Configure script for kafka

yes | cp -f roles/r_and_d/kafka/config/config/* /opt/kafka-2.12/config/.

yes | cp -f roles/r_and_d/kafka/config/kafka.service /etc/systemd/system/multi-user.target.wants/kafka.service

systemctl daemon-reload

systemctl start kafka

