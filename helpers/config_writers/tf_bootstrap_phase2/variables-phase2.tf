
variable domain_name {
    default = "{{domain_name}}"
}
variable "region" {
  type = "string"
}

variable "email" {
  type = "string"
}

variable "do" {
    type = "map"
}

variable "gitlab" {
    type = "map"
}
