# canzea --lifecycle=wire --solution=vault --action=register-secret --args='{"key":"digitalocean","data":{"token":"{{DIGITAL_OCEAN_API_KEY}}"}}'

require 'json'
require 'net/http'
require 'template-runner'
require_relative 'connection'

parameters = JSON.parse(ARGV[0])

key = parameters['key']

payload = parameters['data']

payload.each_pair do |k, v|
    payload[k] = Template.new.processString(v, {})
end


http = Connection.new.prepareHttpPutConnection()

request = Net::HTTP::Post.new("/v1/secret/#{key}")
request['Content-Type'] = 'application/json'
request['X-Vault-Token'] = ENV['VAULT_TOKEN']

res = http.request(request, payload.to_json)

if (Integer(res.code) != 204)
   puts res.code
   puts res.msg
   raise("Unable to register secret #{res.code}")
end
