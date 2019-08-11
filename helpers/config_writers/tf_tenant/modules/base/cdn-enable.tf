resource "canzea_resource" "do_spaces_enable_cdn" {
  path = "/do/cdn"

  attributes = {
      origin = "${var.es_id}-bucket.sfo2.digitaloceanspaces.com"
  }
}
