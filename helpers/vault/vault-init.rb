
require 'json'
require 'net/http'
require 'connection'

parameters = JSON.parse(ARGV[0])

# curl -X PUT -d "{\"secret_shares\":1, \"secret_threshold\":1}" http://127.0.0.1:8200/v1/sys/init

payload = { "secret_shares" => 1, "secret_threshold" => 1 }

headers = {}


http = Connection.new.prepareHttpPutConnection('/v1/sys/init')

res = http.request(request, payload.to_json)

puts res.body

if ( Integer(res.code) != 200 )
    puts res.code
    raise("Initialization of vault failed")
end
