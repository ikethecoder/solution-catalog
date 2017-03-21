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

    active = false
    snapshot = client.snapshots.find(id: item['resource_id'])

    File.open("#{Canzea::config[:pwd]}/vps-#{dropitem['name']}-snapshot-active.json", 'w') { |file| file.write(snapshot.to_json) }
end
