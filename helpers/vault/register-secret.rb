# canzea --lifecycle=wire --solution=vault --action=register-secret --args='{"key":"digitalocean","data":{"token":"{{DIGITAL_OCEAN_API_KEY}}"}}'

require 'json'
require 'net/http'
require 'template-runner'

parameters = JSON.parse(ARGV[0])

key = parameters['key']

payload = parameters['data']

payload.each_pair do |k, v|
    payload[k] = Template.new.processString(v, {})
end

uri = ENV['VAULT_URL'] + "/v1/secret/#{key}"

headers = {
  'X-Vault-Token' => ENV['VAULT_TOKEN'],
  'Content-Type' => 'application/json'
}

http = Net::HTTP.new(ENV['VAULT_ADDRESS'], ENV['VAULT_PORT'])
res = http.post("/v1/secret/#{key}", payload.to_json, headers)

if (Integer(res.code) != 204)
   puts res.msg
   raise("Unable to register secret #{res.code}")
end
