require 'json'
require_relative 'connection'

parameters = JSON.parse(ARGV[0])

http = Connection.new.prepareHttpPutConnection()

payload = { "ServiceID" => parameters['name'] }

request = Net::HTTP::Put.new("/v1/catalog/service/deregister")

res = http.request(request, payload.to_json)

puts res.body

if ( Integer(res.code) != 200 )
    puts res.code
    puts res.body
    raise("Deleting service configuration failed")
end
