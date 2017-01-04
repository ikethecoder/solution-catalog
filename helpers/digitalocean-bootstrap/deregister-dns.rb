require 'droplet_kit'
require 'json'

token=ENV["DIGITALOCEAN_TOKEN"]

parameters = JSON.parse(ARGV[0])

domain = parameters["domain"]
rootHost = parameters["rootHost"]

client = DropletKit::Client.new(access_token: token)

result = []

records = client.domain_records.all(for_domain: rootHost)

records.each do |item|
    if item.type == "A" and item.name == domain.downcase
        status = client.domain_records.delete(for_domain: rootHost, id: item['id'])
        result.push(status)
    end
    if item.type == "CNAME" and item.name == "*.#{domain.downcase}"
        status = client.domain_records.delete(for_domain: rootHost, id: item['id'])
        result.push(status)
    end

end

puts result.to_json