require 'json'
require 'canzea'
require_relative 'connection'

parameters = JSON.parse(ARGV[0])

http = Connection.new.prepareHttpPutConnection()

payload = { "secret_shares" => 1, "secret_threshold" => 1 }

request = Net::HTTP::Put.new("/v1/sys/init")

res = http.request(request, payload.to_json)

if ( Integer(res.code) != 200 )
    puts res.code
    raise("Initialization of vault failed")
end

info = JSON.parse(res.body)

File.open("#{Canzea::config[:pwd]}/vault.json", 'w') { |file| file.write(res.body.to_json) }

key = info['keys'][0]
token = info['root_token']

payload = { "key" => key }

request = Net::HTTP::Put.new("/v1/sys/unseal")
request['Content-Type'] = 'application/json'

res = http.request(request, payload.to_json)

puts res.body

if ( Integer(res.code) != 200 )
    puts res.code
    raise("Unseal of vault failed")
end

# canzea --util=add-env VAULT_TOKEN token
# canzea --util=add-env VAULT_URL "https://vault.service.dc1.consul:8200"
