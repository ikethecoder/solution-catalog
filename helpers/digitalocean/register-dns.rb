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
            "ttl" => 1800
          };

response = client.post("domains/#{rootHost}/records", payload.to_json)
result.push(response)

payload = {
            "type" => "CNAME",
            "name" => "*.#{domain}",
            "data" => "#{domain}.#{rootHost}.",
            "ttl" => 1800
          };
response = client.post("domains/#{rootHost}/records", payload.to_json)
result.push(response)

puts result.to_json
