
require 'droplet_kit'
require 'json'
require 'registry'
require 'canzea/config'

parameters = JSON.parse(ARGV[0])

token = ENV["DIGITALOCEAN_TOKEN"]

client = DropletKit::Client.new(access_token: token)

output = []

images = client.snapshots.all()
images.each { | image |
    puts image['id']
    puts image['name']
    puts image['resource_id']
    puts image['resource_type']
    output.push ( {"id":image['id'], "name":image['name'], "id":image['resource_id']} )
}

puts JSON.pretty_generate(output)