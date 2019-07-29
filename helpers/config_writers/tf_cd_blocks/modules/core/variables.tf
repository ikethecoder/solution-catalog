
variable "pvt_key_data" {
  type = "string"
}

variable "domain_name" {
  type = "string"
}

variable "do_token" {
  type = "string"
}

variable "kube_host" {
  type = "string"
}

variable "kube_client_certificate" {
  type = "string"
}

variable "kube_client_key" {
  type = "string"
}

variable "kube_cluster_ca_certificate" {
  type = "string"
}

variable "domain_tls_certificate_pem" {
  type = "string"
}

variable "domain_tls_private_key_pem" {
  type = "string"
}

variable "domain_tls_issuer_pem" {
  type = "string"
}

variable "base_droplet_id" {
  type = "string"
}

variable "base_proxy_ipv4_address" {
  type = "string"
}

variable "node_cluster" {
  type = "string"
}

# variable "node_cluster_collab" {
#   type = "string"
# }

variable "gitlab" {
  type = "map"
}

variable "acme_account_key" {
  type = "string"
}

variable "source_ssh_ip" {
  type = "string"
}