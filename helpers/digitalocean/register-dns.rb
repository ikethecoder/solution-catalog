require 'json'
require_relative 'client'

token=ENV["DIGITALOCEAN_TOKEN"]

parameters = JSON.parse(ARGV[0])

domain = parameters["domain"]
ip = parameters["ip"]
rootHost = parameters["rootHost"]

client = DOClient.new

result = []

payload = {
            "type" => "A",
            "name" => domain,
            "data" => ip,
            "priority" => null,
            "port" => null,
            "ttl" => 1800,
            "weight" => null
          };

response = client.post("domains/#{rootHost}/records", payload)
result.push(response)

payload = {
            "type" => "CNAME",
            "name" => "*.#{domain}",
            "data" => "#{domain}.#{rootHost}.",
            "priority" => null,
            "port" => null,
            "ttl" => 1800,
            "weight" => null
          };
response = client.post("domains/#{rootHost}/records", payload)
result.push(response)

puts result.to_json
