
curl -X PUT --data "@roles/monitoring/elasticsearch-metrics/config/elasticsearch-metrics.json" http://localhost:9200/_template/elasticsearch_metrics

systemctl daemon-reload
systemctl restart elasticsearch-metrics