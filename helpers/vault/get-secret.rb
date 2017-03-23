# canzea --lifecycle=wire --solution=vault --action=register-secret --args='{"key":"digitalocean","data":{"token":"{{DIGITAL_OCEAN_API_KEY}}"}}'

require 'json'
require 'net/http'
require 'template-runner'
require_relative 'connection'

parameters = JSON.parse(ARGV[0])

key = parameters['key']

http = Connection.new.prepareHttpPutConnection()

request = Net::HTTP::Get.new("/v1/secret/#{key}")
request['Content-Type'] = 'application/json'
request['X-Vault-Token'] = ENV['VAULT_TOKEN']

res = http.request(request)

if (Integer(res.code) != 200)
   puts res.code
   puts res.msg
   raise("Unable to register secret #{res.code}")
end

puts res.body.to_json