
resource "canzea_resource" "source_organization" {
  path = "/source/organization"

  attributes = {
    description = "string"
    full_name = "Ecosystem ${var.es_id} Operations"
    location = "string"
    username = "ecosystem_operations"
    website = "string"
  }

  id_attribute = "username"
}
