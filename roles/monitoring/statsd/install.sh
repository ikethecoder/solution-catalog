

roles/monitoring/statsd/install-statsduser.sh

sudo yum -y install epel-release

sudo yum -y install nodejs

(su statsduser -c "cd ~/ && git clone https://github.com/etsy/statsd.git")

(su statsduser -c "cd ~/statsd && npm install")

# npm install git://github.com/markkimsal/statsd-elasticsearch-backend.git
(su statsduser -c "cd ~/statsd && npm install git://github.com/markkimsal/statsd-elasticsearch-backend.git")

(su statsduser -c "yes | cp -f roles/monitoring/statsd/config/config.js ~/statsd/.")




# (su statsduser -c "cd ~/statsd && node stats.js ./config.js")

# node stats.js ./config.js

# Update /etc/collectd.conf

# npm install

# sudo yum -y install nc

# echo "foo:1|c" | nc -u -w1 127.0.0.1 8126

ruby ./init/template.rb roles/monitoring/statsd/config/statsd.service /etc/systemd/system/multi-user.target.wants/statsd.service

systemctl daemon-reload
