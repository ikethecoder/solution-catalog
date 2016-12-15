require 'droplet_kit'
require 'json'
require 'canzea/config'

parameters = JSON.parse(ARGV[0])

file = File.read("#{Canzea::config[:pwd]}/#{parameters['metadata']}")
response = JSON.parse(file)

token=ENV["DIGITALOCEAN_TOKEN"]

client = DropletKit::Client.new(access_token: token)

response.each do |item|
    puts item['name']

    status = client.droplets.delete(id: item['id'])

    puts status.to_json
end
