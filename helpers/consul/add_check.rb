# ruby helpers/helper-run.rb consul add_check '{"service":"Hello World","address":"integration.escca.canzea.cc", "port":1888}'
# ruby helpers/consul/add_check.rb '{"service":"Hello World","checkUrl":"http://67.205.136.139:8188/health"}'

require 'json'
require 'net/http'
parameters = JSON.parse(ARGV[0])

service = parameters['service']
check = parameters['checkUrl']

# Get the authtoken and userId
uri = URI(ENV['CONSUL_URL'])

headers = {
}

payload =
    {
        "Id" => service, "Name" => "Some check #{service}", "HTTP" => check, "Interval" => "10s", "Timeout": "1s",
    }

puts uri.host
puts uri.port
http = Net::HTTP.new(uri.host, uri.port)
res = http.post("/v1/agent/check/register", payload.to_json, headers)

if ( Integer(res.code) != 200 )
    puts res.code
    puts res.body
    raise("Updating service checks failed")
end