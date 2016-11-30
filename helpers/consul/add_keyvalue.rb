# ruby helpers/helper-run.rb consul add_keyvalue '{"key":"test/a","value":"value"}'

require 'json'
require 'net/http'
parameters = JSON.parse(ARGV[0])

key = parameters['key']
value = parameters['value']

# Get the authtoken and userId
uri = URI(ENV['CONSUL_URL'])

headers = {
}

http = Net::HTTP.new(uri.host, uri.port)
res = http.put("/v1/kv/#{key}", value, headers)

if ( Integer(res.code) != 200 )
    puts res.body
    raise("Adding key value configuration failed")
end