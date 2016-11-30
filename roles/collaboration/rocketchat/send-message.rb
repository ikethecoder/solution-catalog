require 'json'
require 'net/http'

# Get the authtoken and userId
uri = URI(ENV['ROCKETCHAT_URL'] + '/api/login')

res = Net::HTTP.post_form(uri, 'user' => 'admin', 'password' => 'admin1admin')


data = JSON.parse(res.body)

authToken = data['data']['authToken']
userId = data['data']['userId']

headers = {
  'X-Auth-Token' => authToken,
  'X-User-Id' => userId,
  'Content-Type' => 'application/json'
}

http = Net::HTTP.new(ENV['ROCKETCHAT_ADDRESS'], ENV['ROCKETCHAT_PORT'])

res = http.get('/api/publicRooms', headers)

rooms = JSON.parse(res.body)

rooms['rooms'].each do  |room|
    if (room['name'] == ARGV[0])
        # Send Message
        payload = {
                "msg" => ARGV[1]
        }
        res = http.post('/api/rooms/' + room['_id'] + '/send', payload.to_json, headers)
        puts res.code
    end
end