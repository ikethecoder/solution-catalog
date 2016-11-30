
curl -X PUT -d node.json -v http://localhost:8500/v1/catalog/register


curl -X PUT -d @roles/configdb/sample/node.json -v http://localhost:8500/v1/catalog/register


curl -X PUT -d @roles/configdb/sample/service.json -v http://localhost:8500/v1/agent/service/register


curl -X PUT -d 50 http://localhost:8500/v1/kv

# https://github.com/JoergM/consul-examples/tree/master/http_api


curl localhost:8500/v1/catalog/service/rocketchat
