require 'json'
require 'commands/push-config'
require 'template-runner'

is_plus = (ARGV[1] == 'PLUS')

t = Template.new
pc = PushConfig.new "/"


template = %{

    resource "digitalocean_firewall" "{{rid}}" {
      name = "{{rid}}"

      droplet_ids = {{{instanceArray}}}

      inbound_rule = [

      {{#inbound_rule}}
        {
          protocol           = "{{protocol}}"
          port_range         = "{{port_range}}"
          {{#source_tags.length}}
          source_tags   = {{{source_tags}}}
          {{/source_tags.length}}
          {{#source_addresses.length}}
          source_addresses   = {{{source_addresses}}}
          {{/source_addresses.length}}
        },
      {{/inbound_rule}}

      ]

      outbound_rule = [

      {{#outbound_rule}}
        {
          protocol           = "{{protocol}}"
          port_range         = "{{port_range}}"
          {{#destination_tags.length}}
          destination_tags   = {{{destination_tags}}}
          {{/destination_tags.length}}
          {{#destination_addresses.length}}
          destination_addresses   = {{{destination_addresses}}}
          {{/destination_addresses.length}}
        },
      {{/outbound_rule}}

      ]
    }

}



if ARGV[0].start_with? "@"
    params = JSON.parse(File.read(ARGV[0][1,200]))
else
    params = JSON.parse(ARGV[0])
end

resourceId = params.keys[0]
properties = params[resourceId]
properties['rid'] = resourceId;

properties['instanceArray'] = []

if is_plus
    properties['instances'].each { |key|
        properties['instanceArray'].push "${digitalocean_droplet.#{key}.id}"
    }

    output = t.processString template, properties
    pc.write "terraform/modules/#{properties['environment']}/firewall-#{resourceId}.tf", output
else
    pc.backupAndRemove "terraform/modules/#{properties['environment']}/firewall-#{resourceId}.tf"
end

