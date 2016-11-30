
systemctl stop statsd

rm -f /etc/systemd/system/multi-user.target.wants/statsd.service

