require 'json'
require 'commands/push-config'
require 'template-runner'

is_plus = (ARGV[1] == 'PLUS')

t = Template.new
pc = PushConfig.new "/"

if ARGV[0].start_with? "@"
    params = JSON.parse(File.read(ARGV[0][1,100]))
else
    params = JSON.parse(ARGV[0])
end

resourceId = params.keys[0]
properties = params[resourceId]
properties['rid'] = resourceId;

blueprint = properties['blueprint']

datasourceTemplate = properties['template']

dbFile = "#{ENV['CATALOG_LOCATION']}/blueprints/#{blueprint}/dashboards/#{datasourceTemplate}.json"

definition = JSON.parse(File.read(dbFile))
definition.delete('id')
definition['name'] = "{{rid}}"
definition['database'] = "{{database}}"

template = %{
 {
      "monitoring_datasource": {
          "{{rid}}":
                {{{definition}}}
      }
  }
}

if is_plus
    output = t.processString  JSON.pretty_generate(definition), properties
    properties['definition'] = output
    output = t.processString template, properties

    puts output
    pc.write "resources/monitoring_datasource/#{params.keys[0]}.es", output
else
    pc.backupAndRemove "config/monitoring_datasource/#{params.keys[0]}.es"
end