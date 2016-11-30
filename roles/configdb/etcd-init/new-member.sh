
# 1) Add member

# curl http://localhost:2379/v2/members -XPOST -H "Content-Type: application/json" -d '{"name":"xyz", "peerURLs":["http://10.0.0.10:2380"]}'

etcdctl member add infra1 http://10.134.17.234:2380

