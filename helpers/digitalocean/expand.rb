require 'droplet_kit'
require 'json'
require 'registry'
require 'canzea/config'

parameters = JSON.parse(ARGV[0])


base=parameters['base']
instances=Integer(parameters['instances'])
fingerprint=parameters['fingerprint']
region=parameters['region']
size=parameters['size']
image=parameters['image']

ary = []
for i in 1..instances
 id = i.to_s.rjust(2, '0')
 ary.push("#{base}-#{id}")

 # r.exists "/machines/#{base}-#{i}"
end

token=ENV["DIGITAL_OCEAN_API_KEY"]

client = DropletKit::Client.new(access_token: token)

userData = { "CONSUL_URL" => ENV['CONSUL_URL'], "VAULT_TOKEN" => "1234" }

payload = { names: ary, ssh_keys: [fingerprint], region: region, size: size, image: image, private_networking: true, ipv6: false, user_data: JSON.generate(userData) }

puts payload

droplet = DropletKit::Droplet.new( payload )

response = client.droplets.create_multiple(droplet)

File.open("#{Canzea::config[:pwd]}/digital-ocean-instances.json", 'w') { |file| file.write(response.to_json) }

response.each do |item|
    puts item['name']

    # r.register "machines/#{item['name']}", 'id', item['id']
    # r.register "machines/#{item['name']}", 'memory', item['memory']
    # r.register "machines/#{item['name']}", 'vcpus', item['vcpus']
end

file = File.read("#{Canzea::config[:pwd]}/digital-ocean-instances.json")
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

File.open("#{Canzea::config[:pwd]}/digital-ocean-instances-final2.json", 'w') { |file| file.write(response.to_json) }

puts "All instances active."


file = File.read("#{Canzea::config[:pwd]}/digital-ocean-instances-final2.json")
response = JSON.parse(file)

response.each do |item|
    puts item['name']

    item['networks']['v4'].each do |net|
        if net['type'] == "private"
            #r.register "machines/#{item['name']}", 'private_ip', net['ip_address']
        end
        if net['type'] == "public"
            #r.register "machines/#{item['name']}", 'public_ip', net['ip_address']
        end
    end
end
