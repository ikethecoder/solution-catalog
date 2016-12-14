require 'json'
require_relative 'connection'

parameters = JSON.parse(ARGV[0])

userId = parameters['userId']

payload = { "value" => parameters['appId'] }

headers = {
  'X-Vault-Token' => ENV['VAULT_TOKEN'],
  'Content-Type' => 'application/json'
}

http = Net::HTTP.new(ENV['VAULT_ADDRESS'], ENV['VAULT_PORT'])
res = http.post("/v1/auth/app-id/map/user-id/#{userId}", payload.to_json, headers)

puts res.body

if ( Integer(res.code) != 204 )
    puts res.code
    raise("Associating app-id to user-id failed")
end
