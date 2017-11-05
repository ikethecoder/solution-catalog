require 'json'
require 'commands/push-config'
require 'template-runner'

t = Template.new
pc = PushConfig.new

tfvars  = %{

    pvt_key=".es/id_rsa_master_key"
    pub_key=".es/id_rsa_master_key.pub"

}

template = %{

  {{#globals}}
    variable "{{name}}" {}
  {{/globals}}

    provider "{{rid}}" {
      {{#variables}}
        {{name}} = "{{value}}"
      {{/variables}}
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

output = t.processString template, properties
puts "terraform/provider-#{resourceId}.tf",output
pc.write "terraform/provider-#{resourceId}.tf", output

output2 = t.processString tfvars, properties
puts "terraform/terraform.tfvars", output2
pc.write "terraform/terraform.tfvars", output2

