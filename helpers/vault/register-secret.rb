# ruby helpers/helper-run.rb vault register-secret '{"key":"rocketchat/admin", "data":{"password":"admin1admin"}}'

require 'json'
require 'net/http'
parameters = JSON.parse(ARGV[0])

key = parameters['key']

payload = parameters['data']

puts payload.to_json

uri = ENV['VAULT_URL'] + "/v1/secret/#{key}"

headers = {
  'X-Vault-Token' => ENV['VAULT_TOKEN'],
  'Content-Type' => 'application/json'
}

http = Net::HTTP.new(ENV['VAULT_ADDRESS'], ENV['VAULT_PORT'])
res = http.post("/v1/secret/#{key}", payload.to_json, headers)