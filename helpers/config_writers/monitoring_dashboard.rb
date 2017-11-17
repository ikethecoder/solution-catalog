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

dashboardTemplate = properties['template']

dbFile = "#{ENV['CATALOG_LOCATION']}/blueprints/#{blueprint}/dashboards/#{dashboardTemplate}.json"

definition = JSON.parse(File.read(dbFile))
definition = definitions['dashboard']
definition.delete('id')
definition['description'] = "{{description}}"
definition['title'] = "{{title}}"

template = %{
 {
      "monitoring_dashboard": {
          "{{rid}}":
                {{{definition}}}
      }
  }
}

if is_plus
    definition = t.process dbFile, properties
    properties['definition'] = JSON.generate(definition)
    output = t.processString template, properties
    puts output
    pc.write "resources/monitoring_dashboard/#{params.keys[0]}.es", output
else
    pc.backupAndRemove "config/monitoring_dashboard/#{params.keys[0]}.es"
end