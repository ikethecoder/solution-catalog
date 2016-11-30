
require 'json'
require 'net/http'
parameters = JSON.parse(ARGV[0])

# curl -X PUT -d "{\"secret_shares\":1, \"secret_threshold\":1}" http://127.0.0.1:8200/v1/sys/init

payload = { "key" => parameters['key'] }

headers = {
  'Content-Type' => 'application/json'
}

http = Net::HTTP.new(ENV['VAULT_ADDRESS'], ENV['VAULT_PORT'])
res = http.put("/v1/sys/unseal", payload.to_json, headers)

puts res.body

if ( Integer(res.code) != 200 )
    puts res.code
    raise("Unseal of vault failed")
end
