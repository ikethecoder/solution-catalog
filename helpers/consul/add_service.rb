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

# ruby helpers/helper-run.rb consul add_service '{"name":"Elasticsearch","address":$LISTENER_PUB, "serviceName":"Elasticsearch", "tags":{}, "port":9200}'
# ruby helpers/helper-run.rb consul add_service '{"name":"Kibana","address":$LISTENER_PUB, "serviceName":"Kibana", "tags":{}, "port":5601}'
# ruby helpers/helper-run.rb consul add_service '{"name":"Logstash","address":$LISTENER_PUB, "serviceName":"Logstash", "tags":{}, "port":5044}'

# ruby helpers/helper-run.rb consul add_service '{"name":"Vault","address":"10.136.0.48", "serviceName":"Vault", "tags":{}, "port":8200}'
# ruby helpers/helper-run.rb consul add_service '{"name":"statsd","address":"localhost", "serviceName":"statsd", "tags":{}, "port":8125}'
# ruby helpers/helper-run.rb consul add_service '{"name":"Gitlab","address":"localhost", "serviceName":"Gitlab", "tags":{}, "port":90}'
# ruby helpers/helper-run.rb consul add_service '{"name":"Rocket.Chat","address":"localhost", "serviceName":"Rocket.Chat", "tags":{}, "port":8780}'
# ruby helpers/helper-run.rb consul add_service '{"name":"PGAdmin","address":"localhost", "serviceName":"PGAdmin", "tags":{}, "port":5050}'
# ruby helpers/helper-run.rb consul add_service '{"name":"Helpy","address":"localhost", "serviceName":"Helpy", "tags":{}, "port":4444}'
# ruby helpers/helper-run.rb consul add_service '{"name":"Taiga","address":"localhost", "serviceName":"Taiga", "tags":{}, "port":85}'

# 198.199.91.125 , 8188
require 'json'
require 'net/http'
parameters = JSON.parse(ARGV[0])


serviceName = parameters['serviceName']
address = parameters['address']
listener = parameters['listener']
port = Integer(parameters['port'])
prefix = parameters['prefix']
checkPath = parameters['check']
tags = ["urlprefix-#{prefix}", "app"]

if (listener == 'pub')
    address = Net::HTTP.get('169.254.169.254', '/metadata/v1/interfaces/public/0/ipv4/address')
elsif (listener == 'prv')
    address = Net::HTTP.get('169.254.169.254', '/metadata/v1/interfaces/private/0/ipv4/address')
elsif (listener == 'loc')
    address = "localhost"
end
check = { "http" => "http://#{address}:#{port}#{checkPath}" , "interval" => "10s", "timeout" => "1s" }

# Get the authtoken and userId
uri = URI(ENV['CONSUL_URL'])

headers = {
}

payload = {
        "Name" => serviceName, "Service" => serviceName, "Address" => address, "Port" => port, "Tags" => tags, "Check" => check
}

http = Connection.new.prepareHttpPutConnection()

res = http.post('/v1/agent/service/register', payload.to_json, headers)

if ( Integer(res.code) != 200 )
    puts res.body
    raise("Adding service configuration failed")
end
