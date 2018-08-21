require 'json'
require 'commands/push-config'
require 'template-runner'

is_plus = (ARGV[1] == 'PLUS')

t = Template.new
pc = PushConfig.new "/"


template = %{

    resource "digitalocean_firewall" "{{rid}}" {
      name = "{{name}}-22-80-and-443"

      droplet_ids = ["${digitalocean_droplet.{{rid}}.id}"]

      inbound_rule = [
        {
          protocol           = "tcp"
          port_range         = "22"
          source_addresses   = ["0.0.0.0/0", "::/0"]
        },
        {
          protocol           = "tcp"
          port_range         = "80"
          source_addresses   = ["0.0.0.0/0", "::/0"]
        },
        {
          protocol           = "tcp"
          port_range         = "443"
          source_addresses   = ["0.0.0.0/0", "::/0"]
        },
      ]

      outbound_rule = [
        {
          protocol                = "tcp"
          port_range              = "53"
          destination_addresses   = ["0.0.0.0/0", "::/0"]
        },
        {
          protocol                = "udp"
          port_range              = "53"
          destination_addresses   = ["0.0.0.0/0", "::/0"]
        },
        {
          protocol                = "tcp"
          port_range              = "80"
          destination_addresses   = ["0.0.0.0/0", "::/0"]
        },
        {
          protocol                = "tcp"
          port_range              = "443"
          destination_addresses   = ["0.0.0.0/0", "::/0"]
        }
      ]
    }

}



if ARGV[0].start_with? "@"
    params = JSON.parse(File.read(ARGV[0][1,100]))
else
    params = JSON.parse(ARGV[0])
end

resourceId = params.keys[0]
properties = params[resourceId]
properties['rid'] = resourceId;

if is_plus
    output = t.processString template, properties
    pc.write "terraform/modules/#{properties['environment']}/firewall-#{resourceId}.tf", output
else
    pc.backupAndRemove "terraform/modules/#{properties['environment']}/firewall-#{resourceId}.tf"
end

