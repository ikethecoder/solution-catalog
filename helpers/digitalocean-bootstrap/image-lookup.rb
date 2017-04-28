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

    file = File.read("#{Canzea::config[:pwd]}/vps-#{dropitem['name']}-image.json")
    item = JSON.parse(file)
    images = client.images.all(type: 'snapshot')

    images.each { | image |
        if (image['public'] == false and image['name'] == "#{dropitem['name']}-snapshot")
            # puts "--" + "Potential match!"
            # puts "--" + image['id']
            # puts "--" + image['name']
            # puts "--" + image['type']

            File.open("#{Canzea::config[:pwd]}/vps-#{dropitem['name']}-snapshot-active.json", 'w') { |file| file.write(image.to_json) }
            puts image.to_json
        end
    }
end
