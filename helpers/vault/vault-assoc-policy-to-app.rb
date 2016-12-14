require 'json'
require_relative 'connection'

parameters = JSON.parse(ARGV[0])

appId = parameters['appId']

payload = { "value" => parameters['policy'], "display_name" => parameters['displayName'] }

headers = {
  'X-Vault-Token' => ENV['VAULT_TOKEN'],
  'Content-Type' => 'application/json'
}

http = Net::HTTP.new(ENV['VAULT_ADDRESS'], ENV['VAULT_PORT'])
res = http.post("/v1/auth/app-id/map/app-id/#{appId}", payload.to_json, headers)

puts res.body

if ( Integer(res.code) != 204 )
    puts res.code
    raise("Associating policy to app-id failed")
end
