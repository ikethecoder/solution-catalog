require 'droplet_kit'
require 'json'
require 'registry'
require 'canzea/config'
require 'template-runner'

parameters = JSON.parse(ARGV[0])


base=parameters['base']
instances=Integer(parameters['instances'])
fingerprint=parameters['fingerprint']
region=parameters['region']
size=parameters['size']
image=parameters['image']

ecosystem=parameters['ecosystem']
cloudToken=parameters['cloudToken']

ary = []
for i in 1..instances
 id = i.to_s.rjust(2, '0')
 ary.push("#{base}-#{id}")

 # r.exists "/machines/#{base}-#{i}"
end

token=ENV["DIGITALOCEAN_TOKEN"]

client = DropletKit::Client.new(access_token: token)

userData = Template.new.process "#{ENV['CATALOG_LOCATION']}/helpers/digitalocean-bootstrap/config/user-data.txt", {"ECOSYSTEM":ecosystem,"CLOUD_TOKEN":cloudToken}

payload = {
    names: ary,
    ssh_keys: [fingerprint],
    region: region,
    size: size,
    image: image,
    private_networking: true,
    ipv6: false,
    user_data: userData,
    tags: parameters['tags']
}

puts payload

droplet = DropletKit::Droplet.new( payload )

response = client.droplets.create_multiple(droplet)

File.open("#{Canzea::config[:pwd]}/provision-#{base}.json", 'w') { |file| file.write(response.to_json) }

file = File.read("#{Canzea::config[:pwd]}/provision-#{base}.json")
response = JSON.parse(file)

active = false
while active == false
  collectiveLockedAnswer = false

  response.each do |item|
    puts item['name']

    droplet = client.droplets.find(id: item['id'])

    puts droplet.to_json

    if droplet.locked == true
      collectiveLockedAnswer = true
    else
      item['networks'] = droplet.networks;

      droplet.networks.v4.each do |net|
        puts net.ip_address + "," + net.type
      end
    end
  end

  if collectiveLockedAnswer == false
    active = true
  else
    sleep(10.seconds)
  end
end

File.open("#{Canzea::config[:pwd]}/provision-#{base}-active.json", 'w') { |file| file.write(response.to_json) }

puts "All instances active."
