#!/bin/bash

set -e

canzea --lifecycle=wire \
  --solution=ecosystem \
  --action=config \
  --args='{"track":true, "source":"{{CATALOG_LOCATION}}/blocks/grafana/vm/config/grafana.ini","target":"/etc/grafana/grafana.ini","instanceId":"mon-mon-01","solution":"grafana"}'

systemctl restart grafana-server
