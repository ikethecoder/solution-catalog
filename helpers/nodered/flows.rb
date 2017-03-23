# ruby helpers/helper-run.rb rocketchat collaboration-new-channel '{"name":"test5"}'
require 'json'
require 'net/http'
parameters = JSON.parse(ARGV[0])

name = parameters['name']

# Get the authtoken and userId
uri = URI(ENV['NODERED_URL'] + '/admin/auth/token')

res = Net::HTTP.post_form(uri , 'client_id' => 'node-red-admin', 'grant_type' => 'password', 'scope' => '*', 'username' => 'admin', 'password' => 'password')
puts res.body

data = JSON.parse(res.body)

authToken = data['access_token']

headers = {
  'Authorization' => "Bearer #{authToken}",
  'Node-RED-API-Version' => 'v2',
  'Content-Type' => 'application/json'
}

uri = URI(ENV['NODERED_URL'] + '/admin/flows')

http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true

payload = {
    "flows" => [
     {
            "type"=> "tab",
            "id"=> "396c2376.c693dc",
            "label"=> "Sheet 1"
          }
    ]
}

res = http.post("#{uri.path}", payload.to_json, headers)

if ( Integer(res.code) != 200 )
    puts res.code
    puts res.body
    raise("Adding flow failed")
end

puts res.body
