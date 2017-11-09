
require 'git'
require 'json'
require 'net/http'
require 'uri'

parameters = JSON.parse(ARGV[0])

payload = {
    "resources": parameters['resources']
}

headers = {
  'Authorization' => "Bearer #{ENV['NODERED_CANZEA_CONSOLE_TOKEN']}",
  'Node-RED-API-Version' => 'v2',
  'X-Vault-Token' => ENV['VAULT_TOKEN'],
  'Content-Type' => 'application/json'
}

uri = URI(ENV['NODERED_URL'] + '/api/bulk')

http = Net::HTTP.new(uri.host, uri.port)
#http.use_ssl = true

res = http.post("#{uri.path}", payload.to_json, headers)

if ( Integer(res.code) >= 300 )
    puts res.body
    raise("Connection to NodeRed Failed")
end

