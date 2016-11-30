
# Configure Elasticsearch template
(su statsduser -c "cd ~/statsd && export ES_HOST=$ELASTICSEARCH_ADDRESS && sh node_modules/statsd-elasticsearch-backend/es-index-template.sh")

ruby ./init/template.rb roles/monitoring/statsd/config/config.js /home/statsduser/statsd/config.js

chown statsduser:statsduser /home/statsduser/statsd/config.js

ruby ./init/template.rb roles/monitoring/statsd/config/statsd.service /etc/systemd/system/multi-user.target.wants/statsd.service

systemctl daemon-reload
