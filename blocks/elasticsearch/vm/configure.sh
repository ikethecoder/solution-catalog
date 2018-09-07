
canzea --config_git_commit --template=blocks/elasticsearch/vm/config/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml

systemctl start elasticsearch

# Try 15 times to connect to Elasticsearch
cmd="curl -XGET "$ELASTICSEARCH_URL"/_cat/health"; for i in {1..20}; do if $cmd; then echo "OK"; break; else echo "Retrying $i"; sleep 10; fi; if [ $i = 15 ]; then echo "FAILED"; exit 1; fi done

# Custom template for Elasticsearch
blocks/elasticsearch/vm/custom_template.atomic.sh

# Set the max result window for exporting/importing object
curl -XPUT $ELASTICSEARCH_URL/.kibana/_settings -d '{ "index" : { "max_result_window" : 2147483647 } }'

curl -s -XGET $ELASTICSEARCH_URL/.kibana/_settings?pretty

systemctl stop elasticsearch
