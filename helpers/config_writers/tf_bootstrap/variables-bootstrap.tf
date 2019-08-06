
variable domain_name {
  type = "string"
  default = "{{domain_name}}"
}

variable "region" {
  type = "string"
  default = "{{region}}"
}

variable "email" {
  type = "string"
  default = "{{email}}"
}

variable "do" {
  type = "map"
  default = {
    spaces_access_id = ""
    spaces_secret_key = ""
  }
}


variable "es_id" {
  type = "string"
  default = "{{es_id}}"
}
