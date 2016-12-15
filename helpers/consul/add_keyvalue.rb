# ruby helpers/helper-run.rb consul add_keyvalue '{"key":"test/a","value":"value"}'

require 'json'
require_relative 'connection'

parameters = JSON.parse(ARGV[0])

key = parameters['key']
value = parameters['value']

http = Connection.new.prepareHttpPutConnection()

request = Net::HTTP::Put.new("/v1/kv/#{key}")

res = http.request(request, value)

if ( Integer(res.code) != 200 )
    puts res.code
    puts res.body
    raise("Adding key value configuration failed")
end