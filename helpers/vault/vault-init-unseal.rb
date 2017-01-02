require 'json'
require 'canzea'
require 'canzea/add-env'
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

File.open("#{Canzea::config[:pwd]}/vault.json", 'w') { |file| file.write(info.to_json) }

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

AddEnv.new.add "VAULT_TOKEN", token
