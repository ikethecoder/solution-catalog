{
  "server": true,
  "node_name": "${NODE_NAME}",
  "datacenter": "dc1",
  "data_dir": "${CONSUL_DATA_PATH}",
  "bind_addr": "0.0.0.0",
  "client_addr": "0.0.0.0",
  "advertise_addr": "${ADVERTISE_ADDR}",
  "bootstrap_expect": 1,
  "retry_join": ["${JOIN1}"],
  "ui": true,
  "log_level": "INFO",
  "enable_syslog": true,
  "acl_enforce_version_8": false
}