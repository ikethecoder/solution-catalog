require 'json'
require_relative 'connection'

parameters = JSON.parse(ARGV[0])

payload = { "secret_shares" => 1, "secret_threshold" => 1 }

headers = {}

http = Connection.new.prepareHttpPutConnection()

request = Net::HTTP::Put.new("/v1/sys/init")

res = http.request(request, payload.to_json, headers)

puts res.body

if ( Integer(res.code) != 200 )
    puts res.code
    raise("Initialization of vault failed")
end
