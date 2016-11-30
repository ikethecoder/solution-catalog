# ruby helpers/helper-run.rb rocketchat collaboration-new-channel '{"name":"test5"}'
require 'json'
require 'net/http'
parameters = JSON.parse(ARGV[0])

name = parameters['name']

# Get the authtoken and userId
uri = URI(ENV['ROCKETCHAT_URL'] + '/api/login')

res = Net::HTTP.post_form(uri, 'user' => 'admin', 'password' => ENV['ADMIN_ROCKETCHAT_PASSWORD'])
puts res.body

data = JSON.parse(res.body)

authToken = data['data']['authToken']
userId = data['data']['userId']

headers = {
  'X-Auth-Token' => authToken,
  'X-User-Id' => userId,
  'Content-Type' => 'application/json'
}

# Create Room
payload = {
        "rooms" => [ { "name" => name, "members" => ["admin"] } ]
}
http = Net::HTTP.new(ENV['ROCKETCHAT_ADDRESS'], ENV['ROCKETCHAT_PORT'])
res = http.post('/api/bulk/createRoom', payload.to_json, headers)

if ( Integer(res.code) == 400 )
    puts res.body
    raise("Creation of new channel failed")
end
