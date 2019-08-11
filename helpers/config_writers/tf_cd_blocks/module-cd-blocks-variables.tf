variable gitlab {
    type = "map"
    default = {
        username  = ""
        password = ""
    }
}

variable flows_git {
    type = "map"
    default = {
        user = "ikethecoder"
        email = "ikethecoder@canzea.com"
        name = "ecosystem_flows"
        url = "https://gitlab.com/ikethecoder/provider-gateway-flows.git"
        secret = "credentials"
    }
}

variable "es_id" {
  type = "string"
  default = "{{es_id}}"
}