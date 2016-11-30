require 'droplet_kit'
require 'json'
require_relative '../../init/registry'

parameters = JSON.parse(ARGV[0])

r = Registry.new

base=parameters['base']
instances=Integer(parameters['instances'])

token=ENV["DIGITAL_OCEAN_API_KEY"]

client = DropletKit::Client.new(access_token: token)

for i in 1..instances
    id = i.to_s.rjust(2, '0')
    did = r.getValue "nodes/#{base}-#{id}", "id"

    item = client.droplet_actions.snapshot(droplet_id: did, name: "#{base}-#{i}-snapshot")

    File.open("vps-#{base}-#{i}-image.json", 'w') { |file| file.write(item.to_json) }

    puts "#{item['id']} #{item['status']}"

    file = File.read("vps-#{base}-#{i}-image.json")
    item = JSON.parse(file)

    active = false
    while active == false

        puts "Looking up: #{item['id']}"

        image = client.droplet_actions.find(droplet_id: item['resource_id'], id: item['id'])

        puts image.to_json

        if image.status == "in-progress"
            sleep(10.seconds)
        else
            active = true
        end
    end
end
