variable "admin_username" {
  type = "string"
}

variable "admin_password" {
  type = "string"
}

variable "providergw_host" {
    type = "string"
}

variable "module_depends_on" {
    type = "string"
}

variable "gitlab_username" {
    type = "string"
}
variable "gitlab_password" {
    type = "string"
}

variable "flows_git" {
    type = "map"
}
