
curl -XPUT http://localhost:9200 -d@roles/monitoring/elasticsearch-metrics/config/elasticsearch-metrics.json

systemctl daemon-reload
systemctl start elasticsearch-metrics