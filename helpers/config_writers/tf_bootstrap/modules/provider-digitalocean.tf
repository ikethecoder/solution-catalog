provider "digitalocean" {
    version = "1.18.0"
    token = "${var.do["token"]}"
    spaces_access_id = "${var.do["spaces_access_id"]}"
    spaces_secret_key = "${var.do["spaces_secret_key"]}"
}
