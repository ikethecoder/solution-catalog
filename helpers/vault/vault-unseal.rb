require 'json'
require_relative 'connection'

parameters = JSON.parse(ARGV[0])
http = Connection.new.prepareHttpPutConnection()

payload = { "key" => parameters['key'] }

request = Net::HTTP::Put.new("/v1/sys/unseal")
request['Content-Type'] = 'application/json'

res = http.request(request, payload.to_json)

puts res.body

if ( Integer(res.code) != 200 )
    puts res.code
    raise("Unseal of vault failed")
end
