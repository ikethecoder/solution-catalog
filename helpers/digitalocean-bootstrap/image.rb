require 'droplet_kit'
require 'json'
require 'canzea/config'

parameters = JSON.parse(ARGV[0])

token=ENV["DIGITALOCEAN_TOKEN"]

client = DropletKit::Client.new(access_token: token)

file = File.read("#{Canzea::config[:pwd]}/#{parameters['metadata']}")
response = JSON.parse(file)

response.each do |dropitem|
    puts dropitem['name']

    did = dropitem['id']

    item = client.droplet_actions.snapshot(droplet_id: did, name: "#{dropitem['name']}-snapshot")

    File.open("#{Canzea::config[:pwd]}/vps-#{dropitem['name']}-image.json", 'w') { |file| file.write(item.to_json) }

    puts "#{item['id']} #{item['status']}"

    file = File.read("#{Canzea::config[:pwd]}/vps-#{dropitem['name']}-image.json")
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
