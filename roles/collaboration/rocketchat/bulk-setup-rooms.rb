require 'json'
require 'net/http'

# Get the authtoken and userId
uri = URI('http://localhost:8780/api/login')

res = Net::HTTP.post_form(uri, 'user' => 'joe6', 'password' => 'joe1joe1')
puts res.body

data = JSON.parse(res.body)

authToken = data['data']['authToken']
userId = data['data']['userId']

headers = {
  'X-Auth-Token' => authToken,
  'X-User-Id' => userId,
  'Content-Type' => 'application/json'
}

# Create Rooms
payload = {
        "rooms" => [ { "name" => "dev", "members" => ["joe6", "billy"] } ]
}
http = Net::HTTP.new('localhost', 8780)
res = http.post('/api/bulk/createRoom', payload.to_json, headers)
puts res.code

