require 'json'
require 'commands/push-config'
require 'template-runner'

is_plus = (ARGV[1] == 'PLUS')

t = Template.new
pc = PushConfig.new "/"

domainTemplate = %{

    resource "digitalocean_domain" "{{domain-id}}" {
      name       = "{{domain}}"
      ip_address = "${digitalocean_droplet.{{droplet}}.ipv4_address}"
    }
}

template = %{


    # Add a record to the domain
  {{#a}}
    resource "digitalocean_record" "{{name}}" {
      domain = "${digitalocean_domain.{{domain-id}}.name}"
      type   = "A"
      name   = "{{name}}"
      value  = "{{address}}"
    }
  {{/a}}

  {{#cname}}
    resource "digitalocean_record" "{{name}}" {
      domain = "${digitalocean_domain.{{domain-id}}.name}"
      type   = "CNAME"
      name   = "{{name}}"
      value  = "{{address}}"
    }
  {{/cname}}

}

if ARGV[0].start_with? "@"
    params = JSON.parse(File.read(ARGV[0][1,100]))
else
    params = JSON.parse(ARGV[0])
end

resourceId = params.keys[0]
properties = params[resourceId]
properties['rid'] = resourceId;

domainFile = "terraform/modules/#{properties['environment']}/domain-#{properties['domain-id']}.tf"

if is_plus
    output = t.processString template, properties

    puts output
    pc.write "terraform/modules/#{properties['environment']}/dns-#{resourceId}.tf", output

    if properties.has_key? "a"
    else
        pc.write domainFile, t.processString(domainTemplate, properties)
    end

else
    pc.backupAndRemove "terraform/modules/#{properties['environment']}/dns-#{resourceId}.tf"
    if properties.has_key? "a"
    else
        pc.backupAndRemove domainFile
    end
end
