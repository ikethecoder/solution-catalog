require 'json'
require 'net/http'
parameters = JSON.parse(ARGV[0])

payload = { "app_id" => parameters['appId'], "user_id" => parameters['userId'] }

headers = {
  'Content-Type' => 'application/json'
}

http = Net::HTTP.new(ENV['VAULT_ADDRESS'], ENV['VAULT_PORT'])
res = http.post("/v1/auth/app-id/login", payload.to_json, headers)

puts res.body

if ( Integer(res.code) != 200 )
    puts res.code
    raise("Enabling app-id failed")
end
