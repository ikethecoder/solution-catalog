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

    item = client.droplet_actions.shutdown(droplet_id: did)

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
