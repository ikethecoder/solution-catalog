#!/bin/bash

export ES_METRICS_CLUSTER_URL=http://localhost:9200
export ES_METRICS_MONITORING_CLUSTER_URL=http://localhost:9200

REPO_BASE=$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )

/usr/bin/python2.7 /opt/elasticsearch-grafana/elasticsearch2elastic.py

