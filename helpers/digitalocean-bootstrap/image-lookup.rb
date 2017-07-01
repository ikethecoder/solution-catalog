require 'droplet_kit'
require 'json'
require 'canzea/config'

parameters = JSON.parse(ARGV[0])

token=ENV["DIGITALOCEAN_TOKEN"]

client = DropletKit::Client.new(access_token: token)

name = parameters['name']

file = File.read("#{Canzea::config[:pwd]}/vps-#{name}-image.json")
item = JSON.parse(file)
images = client.images.all(type: 'snapshot')

match = false

images.each { | image |
    if (image['public'] == false and image['name'] == "#{name}-snapshot")
        # puts "--" + "Potential match!"
        # puts "--" + image['id']
        # puts "--" + image['name']
        # puts "--" + image['type']

        File.open("#{Canzea::config[:pwd]}/vps-#{name}-snapshot-active.json", 'w') { |file| file.write(image.to_json) }
        puts image.to_json
        match = true
    end
}

if match == false
    raise "Image not found"
end
