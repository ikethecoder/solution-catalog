require 'json'
require_relative 'connection'

parameters = JSON.parse(ARGV[0])

http = Connection.new.prepareHttpPutConnection()

request = Net::HTTP::Get.new("/v1/agent/services")

res = http.request(request)

puts JSON.pretty_generate(JSON.parse(res.body))

if ( Integer(res.code) != 200 )
    puts res.code
    puts res.body
    raise("Getting service list failed.")
end
