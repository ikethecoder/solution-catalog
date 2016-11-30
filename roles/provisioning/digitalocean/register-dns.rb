require 'droplet_kit'
require 'json'

token=ENV["DIGITAL_OCEAN_API_KEY"]

domain = ARGV[0]
ip = ARGV[1]
rootHost = ARGV[2]

client = DropletKit::Client.new(access_token: token)

result = []

# Needs the ecosystem reference id and the environment information
record = DropletKit::DomainRecord.new(type: 'A', name: domain, data: ip)
response = client.domain_records.create(record, for_domain: rootHost)
result.push(response)

record = DropletKit::DomainRecord.new(type: 'CNAME', name: "*.#{domain}", data: "#{domain}.#{rootHost}.")
response = client.domain_records.create(record, for_domain: rootHost)
result.push(response)

puts result.to_json
