
# Spring Boot blocks

#########################################################
# Getting slow start time on SecureRandom; this fixes it
#########################################################
yum install -y rng-tools

chkconfig rngd on

yes | cp prod-1/Files/usr/lib/systemd/system/rngd.service /usr/lib/systemd/system/.

systemctl daemon-reload

systemctl start rngd

