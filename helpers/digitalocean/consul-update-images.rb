require 'droplet_kit'
require 'json'
require 'registry'
require 'canzea/config'

parameters = JSON.parse(ARGV[0])

r = Registry.new

base=parameters['base']
instances=Integer(parameters['instances'])

for i in 1..instances

    file = File.read("#{Canzea::config[:pwd]}/vps-#{base}-#{i}-image.json")
    item = JSON.parse(file)

    puts item['id']

    r.register "images/#{base}-#{i}", 'id', item['id']
    r.register "images/#{base}-#{i}", 'resource_id', item['resource_id']
end