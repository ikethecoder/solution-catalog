
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
    spaces_access_key = ""
    spaces_secret_key = ""
  }
}