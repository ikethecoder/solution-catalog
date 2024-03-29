require 'droplet_kit'
require 'json'
require 'canzea/config'

parameters = JSON.parse(ARGV[0])

token=ENV["DIGITALOCEAN_TOKEN"]

client = DropletKit::Client.new(access_token: token)

name = parameters['name']

puts name

did = parameters['dropletId']

item = client.droplet_actions.snapshot(droplet_id: did, name: "#{name}-snapshot")

File.open("#{Canzea::config[:pwd]}/vps-#{name}-image.json", 'w') { |file| file.write(item.to_json) }

puts "#{item['id']} #{item['status']}"

file = File.read("#{Canzea::config[:pwd]}/vps-#{name}-image.json")
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

        File.open("#{Canzea::config[:pwd]}/vps-#{name}-image-active.json", 'w') { |file| file.write(image.to_json) }

    end
end
