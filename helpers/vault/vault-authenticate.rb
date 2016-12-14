require 'json'
require_relative 'connection'

parameters = JSON.parse(ARGV[0])

http = Connection.new.prepareHttpPutConnection()

payload = { "app_id" => parameters['appId'], "user_id" => parameters['userId'] }

request = Net::HTTP::Put.new("/v1/auth/app-id/login")
request['Content-Type'] = 'application/json'
request['X-Vault-Token'] = ENV['VAULT_TOKEN']

res = http.request(request, payload.to_json)

puts res.body

if ( Integer(res.code) != 200 )
    puts res.code
    raise("Enabling app-id failed")
end
