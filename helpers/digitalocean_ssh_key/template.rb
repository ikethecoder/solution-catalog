
resource "digitalocean_ssh_key" "{{name}}" {
  name       = "{{name}}"
  public_key = "${file("keys/{{data.public_key}}")}"
}
