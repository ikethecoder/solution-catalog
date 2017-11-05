require 'json'

require 'commands/push-config'
require 'template-runner'

t = Template.new
pc = PushConfig.new

module_vars_tmpl = %{
  {{#variables}}
    variable {{name}} {}
  {{/variables}}
}


template = %{
    module "{{rid}}" {
        source = "./modules/{{rid}}"
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

output0 = t.processString template, properties

puts "terraform/modules/module-#{resourceId}.tf", output0


output = t.processString module_vars_tmpl, properties

puts "terraform/modules/#{resourceId}/variables.tf", output

pc.write "terraform/module-#{resourceId}.tf", output0
pc.write "terraform/modules/#{resourceId}/variables.tf", output
