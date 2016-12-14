require 'json'
require_relative 'connection'

parameters = JSON.parse(ARGV[0])

http = Connection.new.prepareHttpPutConnection()

userId = parameters['userId']
payload = { "value" => parameters['appId'] }

request = Net::HTTP::Put.new("/v1/auth/app-id/map/user-id/#{userId}")
request['Content-Type'] = 'application/json'
request['X-Vault-Token'] = ENV['VAULT_TOKEN']

res = http.request(request, payload.to_json)

puts res.body

if ( Integer(res.code) != 204 )
    puts res.code
    raise("Associating app-id to user-id failed")
end
