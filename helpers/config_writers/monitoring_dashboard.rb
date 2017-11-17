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

dashboardTmplate = properties['template']

template = %{
 {
      "monitoring_dashboard": {
          "{{rid}}": {
                {{{definition}}}
          }
      }
  }
}

if is_plus
    definition = t.process "#{ENV['CATALOG_LOCATION']}/blueprints/#{blueprint}/dashboards/#{dashboardTmplate}.json", properties
    properties['definition'] = definition
    output = t.processString template, properties
    puts output
    pc.write "resources/monitoring_dashboard/#{params.keys[0]}.es", output
else
    pc.backupAndRemove "config/monitoring_dashboard/#{params.keys[0]}.es"
end