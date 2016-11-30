require 'droplet_kit'
require 'json'
require_relative '../../../init/registry'

r = Registry.new

base=ARGV[0]
instances=Integer(ARGV[1])

ary = []
for i in 1..instances
 id = i.to_s.rjust(2, '0')
 ary.push(r.getValue "nodes/#{base}-#{id}", "id")
end

token=ENV["DIGITAL_OCEAN_API_KEY"]

client = DropletKit::Client.new(access_token: token)

for id in ary
    status = client.droplets.delete(id: id)

    puts status.to_json
end

for i in 1..instances
    r.deleteDirectory "nodes/#{base}-#{i}"
end

