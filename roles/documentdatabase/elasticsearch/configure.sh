
canzea --config_git_commit --template=roles/documentdatabase/elasticsearch/config/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml

systemctl start elasticsearch

# Try 5 times to connect to Elasticsearch
cmd="curl -XGET "$ELASTICSEARCH_URL"/_cat/health"; for i in {1..5}; do if $cmd; then echo "OK"; break; else echo "Retrying $i"; sleep 5; fi; if [ $i = 4 ]; then echo "FAILED"; exit 1; fi done

# Custom template for Elasticsearch
roles/documentdatabase/elasticsearch/custom_template.atomic.sh

# Set the max result window for exporting/importing object
curl -XPUT $ELASTICSEARCH_URL/.kibana/_settings -d '{ "index" : { "max_result_window" : 2147483647 } }'

curl -s -XGET $ELASTICSEARCH_URL/.kibana/_settings?pretty

systemctl stop elasticsearch
