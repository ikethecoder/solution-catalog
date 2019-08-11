ui = "true"

listener "tcp" {
  address          = "0.0.0.0:8200"
  cluster_address  = "0.0.0.0:8201"
  tls_disable      = "false"
  tls_cert_file    = "/etc/certs/host.crt"
  tls_key_file     = "/etc/certs/host.key"
}

storage "consul" {
  address = "127.0.0.1:8500"
  path    = "vault/"
}

api_addr =  "${API_ADDR}"
cluster_addr = "${CLUSTER_ADDR}"
