# ruby helpers/helper-run.rb consul add_service '{"name":"Go.CD","address":"localhost", "port":8153}'
# ruby helpers/helper-run.rb consul add_service '{"name":"Archiva","address":"10.136.19.212", "port":9080}'

# ruby helpers/helper-run.rb consul add_service '{"name":"Logstash","address":"10.136.17.199", "port":5044}'
# ruby helpers/helper-run.rb consul add_service '{"name":"Vault","address":"10.136.16.13", "port":8200}'

# ruby helpers/helper-run.rb consul add_service '{"name":"PhantomJS","address":"162.243.163.185", "port":8001}'
# ruby helpers/helper-run.rb consul add_service '{"name":"statsd","address":"10.136.23.156", "port":8125}'
# ruby helpers/helper-run.rb consul add_service '{"name":"Gitlab","address":"localhost", "port":90}'
# ruby helpers/helper-run.rb consul add_service '{"name":"Hello World","address":"integration.escca.canzea.cc", "port":1888}'
# ruby helpers/helper-run.rb consul add_service '{"name":"Hello World","address":"67.205.136.139", "port":8188}'


# ruby helpers/helper-run.rb consul add_service '{"name":"hello-world-integration-c-01-8188","address":"67.205.152.165", "port":8188, "tags":["urlprefix-/hello-world", "app"], "check":{"http":"http://67.205.152.165:8188/health", "interval":"10s", "timeout":"1s"}}'
# curl http://localhost:9999/hello-world?name=Aidan

# 198.199.91.125 , 8188
require 'json'
require 'net/http'
parameters = JSON.parse(ARGV[0])

name = parameters['name']
address = parameters['address']
port = parameters['port']
tags = parameters['tags']
check = parameters['check']

# Get the authtoken and userId
uri = URI(ENV['CONSUL_URL'])

headers = {
}

payload = {
        "Name" => name, "Service" => name, "Address" => address, "Port" => port, "Tags" => tags, "Check" => check
}

http = Net::HTTP.new(uri.host, uri.port)
res = http.post('/v1/agent/service/register', payload.to_json, headers)

if ( Integer(res.code) != 200 )
    puts res.body
    raise("Adding service configuration failed")
end
