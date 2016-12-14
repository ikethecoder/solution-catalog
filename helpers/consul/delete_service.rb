require 'json'
require_relative 'connection'

parameters = JSON.parse(ARGV[0])

http = Connection.new.prepareHttpPutConnection()

request = Net::HTTP::Delete.new("/v1/agent/service/deregister/#{parameters['service_id']}")

res = http.request(request)

puts res.body

if ( Integer(res.code) != 200 )
    puts res.code
    puts res.body
    raise("Deleting service configuration failed")
end
