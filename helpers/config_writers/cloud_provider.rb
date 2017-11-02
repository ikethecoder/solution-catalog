require 'json'
require 'commands/push-config'
require 'template-runner'

t = Template.new
pc = PushConfig.new

template = %{

  {{#props.globals}}
    variable "{{name}}" {}
  {{/props.globals}}

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

puts output

pc.write "terraform/modules/module-{{resourceId}}.tf", output
