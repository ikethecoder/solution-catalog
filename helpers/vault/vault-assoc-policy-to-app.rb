require 'json'
require_relative 'connection'

parameters = JSON.parse(ARGV[0])

http = Connection.new.prepareHttpPutConnection()

appId = parameters['appId']

payload = { "value" => parameters['policy'], "display_name" => parameters['displayName'] }

request = Net::HTTP::Put.new("/v1/auth/app-id/map/app-id/#{appId}")
request['Content-Type'] = 'application/json'
request['X-Vault-Token'] = ENV['VAULT_TOKEN']

res = http.request(request, payload.to_json)

puts res.body

if ( Integer(res.code) != 204 )
    puts res.code
    raise("Associating policy to app-id failed")
end
