require 'json'
require 'canzea'
require_relative 'connection'

parameters = JSON.parse(ARGV[0])

http = Connection.new.prepareHttpPutConnection()

payload = { "secret_shares" => 1, "secret_threshold" => 1 }

request = Net::HTTP::Put.new("/v1/sys/init")

res = http.request(request, payload.to_json)

# {"keys":["63f4c80fcd73c64937c430bd922193df13b95a1ca596bd9f32bbe42e2d3d9243"],"root_token":"30db3502-ca03-8456-0810-6ec59f964fd9"}

if ( Integer(res.code) != 200 )
    puts res.code
    raise("Initialization of vault failed")
end

info = JSON.parse(res.body)

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


extraConfig = Canzea::config[:catalog_location] + "/env.json"

env = JSON.parse(File.read(extraConfig))
env['VAULT_TOKEN'] = token
env['VAULT_URL'] = "https://vault.service.dc1.consul:8200"

File.write(extraConfig, JSON.generate(env))