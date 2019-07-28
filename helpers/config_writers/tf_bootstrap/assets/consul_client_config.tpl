{
  "server": false,
  "datacenter": "dc1",
  "node_name": "$NODE_NAME",
  "data_dir": "$CONSUL_DATA_PATH",
  "bind_addr": "$BIND_ADDR",
  "client_addr": "127.0.0.1",
  "retry_join": ["$JOIN1", "$JOIN2", "$JOIN3"],
  "log_level": "DEBUG",
  "enable_syslog": true,
  "acl_enforce_version_8": false
}