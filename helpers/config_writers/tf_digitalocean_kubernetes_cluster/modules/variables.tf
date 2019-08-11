

# Configured by bootstrap

# variable region {
#     default = "{{region}}"
# }
# variable domain_name {
#     default = "{{domain_name}}"
# }


variable domain_name {
  type = "string"
}

variable "region" {
  type = "string"
}

variable "do" {
  type = "map"
}

variable "cluster_id" {

}

variable kube_version {}
variable node_pool_size {}
variable node_pool_count {}