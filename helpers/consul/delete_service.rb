require 'json'
require_relative 'connection'

parameters = JSON.parse(ARGV[0])

http = Connection.new.prepareHttpPutConnection()

appId = parameters['appId']

payload = { "value" => parameters['policy'], "display_name" => parameters['displayName'] }

request = Net::HTTP::Delete.new("/v1/agent/service/unregister/#{name}")

res = http.request(request, payload.to_json)

if ( Integer(res.code) != 200 )
    puts res.body
    raise("Deleting service configuration failed")
end
