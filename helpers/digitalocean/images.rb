
require 'droplet_kit'
require 'json'
require 'registry'
require 'canzea/config'

parameters = JSON.parse(ARGV[0])

token = ENV["DIGITAL_OCEAN_API_KEY"]

client = DropletKit::Client.new(access_token: token)

output = []

images = client.images.all(type: 'snapshot')
images.each { | image |
    if (image['type'] == "snapshot")
        puts image['id']
        puts image['type']
        output.push ( {"id":image['id'], "name":image['name']} )
    end
}

puts JSON.pretty_generate(output)