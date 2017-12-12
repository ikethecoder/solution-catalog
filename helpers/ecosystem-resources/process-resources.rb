
require 'git'
require 'json'
require 'net/http'
require 'uri'

parameters = JSON.parse(ARGV[0])

payload = {
    "resources" => parameters['resources']
}

headers = {
  'Authorization' => "Bearer #{ENV['NODERED_CANZEA_CONSOLE_TOKEN']}",
  'Node-RED-API-Version' => 'v2',
  'X-Vault-Token' => ENV['VAULT_TOKEN'],
  'Content-Type' => 'application/json'
}

uri = URI(ENV['NODERED_URL'] + '/gw/api/bulk')

http = Net::HTTP.new(uri.host, uri.port)
#http.use_ssl = true

res = http.post("#{uri.path}", payload.to_json, headers)

if ( Integer(res.code) >= 300 )
    puts res.body
    raise("Connection to NodeRed Failed")
end

data = JSON.parse(res.body)

data.each { | request |
    if Integer(request['statusCode']) >= 300
        raise("Atleast one resource request failed. " + res.body)
    end
}
puts res.body
