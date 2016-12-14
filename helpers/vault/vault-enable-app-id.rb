require 'json'
require_relative 'connection'

parameters = JSON.parse(ARGV[0])

payload = { "type" => "app-id" }

headers = {
  'X-Vault-Token' => ENV['VAULT_TOKEN'],
  'Content-Type' => 'application/json'
}

http = Net::HTTP.new(ENV['VAULT_ADDRESS'], ENV['VAULT_PORT'])
res = http.post("/v1/sys/auth/app-id", payload.to_json, headers)

puts res.body

if ( Integer(res.code) != 204 )
    puts res.code
    raise("Enabling app-id failed")
end
