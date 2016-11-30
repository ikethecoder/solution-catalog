require 'json'
require 'net/http'

parameters = JSON.parse(ARGV[0])

# Get the authtoken and userId
uri = URI(ENV['GITLAB_URL'] + '/api/v3/session')

res = Net::HTTP.post_form(uri, 'login' => 'root', 'password' => 'admin1admin1')

data = JSON.parse(res.body)

privateToken = data['private_token']

# Create User
headers = {
        'Content-Type' => 'application/json'
}
payload = {
        "name" => parameters['name'],
        "username" => parameters['name'],
        "email" => parameters['email'],
        "password" => parameters['password']
}
http = Net::HTTP.new(ENV['GITLAB_ADDRESS'], ENV['GITLAB_PORT'])
res = http.post("/api/v3/users?private_token=#{privateToken}", payload.to_json, headers)

if ( Integer(res.code) != 201 )
    puts res.body
    raise("Adding user failed")
end
