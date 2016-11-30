require 'droplet_kit'
require 'json'
require 'registry'
require 'canzea/config'

parameters = JSON.parse(ARGV[0])

r = Registry.new

file = File.read("#{Canzea::config[:pwd]}/#{parameters['metadata']}")
response = JSON.parse(file)

response.each do |item|
    puts item['name']

    r.register "nodes/#{item['name']}", 'id', item['id']
    r.register "nodes/#{item['name']}", 'memory', item['memory']
    r.register "nodes/#{item['name']}", 'vcpus', item['vcpus']

    item['networks']['v4'].each do |net|
        if net['type'] == "private"
            r.register "nodes/#{item['name']}", 'private_ip', net['ip_address']
        end
        if net['type'] == "public"
            r.register "nodes/#{item['name']}", 'public_ip', net['ip_address']
        end
    end
end
