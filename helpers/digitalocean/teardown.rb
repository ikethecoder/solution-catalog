require 'droplet_kit'
require 'json'
require 'registry'
require 'canzea/config'

parameters = JSON.parse(ARGV[0])

r = Registry.new

base=parameters['base']
instances=Integer(parameters['instances'])

ary = []
for i in 1..instances
    id = i.to_s.rjust(2, '0')
    ary.push(r.getValue "nodes/#{base}-#{id}", "id")
end

token=ENV["DIGITALOCEAN_TOKEN"]

client = DropletKit::Client.new(access_token: token)

for id in ary
    status = client.droplets.delete(id: id)

    puts status.to_json
end

for i in 1..instances
    id = i.to_s.rjust(2, '0')
    r.deleteDirectory "nodes/#{base}-#{id}"
end

