# ruby helpers/helper-run.rb rocketchat collaboration-send-message '{"channel":"EnvBuild", "message":"Goodness"}'

require 'json'
require 'net/http'
parameters = JSON.parse(ARGV[0])

channel = parameters['channel']
message = parameters['message']

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

roomId = 0;

http = Net::HTTP.new(ENV['ROCKETCHAT_ADDRESS'], ENV['ROCKETCHAT_PORT'])

res = http.get('/api/publicRooms', headers)

content = JSON.parse(res.body)

content['rooms'].each do | room |
    puts room['name']
    if (room['name'] == channel)
        roomId = room['_id']
        break
    end
end

puts "SENDING TO #{roomId}"

payload = {
        "msg" => message
}
res = http.post("/api/rooms/#{roomId}/send", payload.to_json, headers)

if ( Integer(res.code) != 200 )
    puts res.body
    raise("Sending message to channel failed")
end
