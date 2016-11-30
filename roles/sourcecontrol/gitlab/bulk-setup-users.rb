require 'json'
require 'net/http'

# Get the authtoken and userId
uri = URI(ENV['GITLAB_URL'] + '/api/v3/session')

res = Net::HTTP.post_form(uri, 'login' => 'root', 'password' => 'admin1admin1')
puts res.body

data = JSON.parse(res.body)

privateToken = data['private_token']
puts privateToken

#curl -L -X POST http://104.236.136.167/api/v3/projects?private_token=SQNjo1xsruyhbwben9Hk -d "name=shit&public=true"

# Create User
headers = {
        'Content-Type' => 'application/json' 
}
payload = {
        "name" => "Aidan",
        "username" => "aidanc",
        "email" => "aidan.cope@gmail.com",
        "password" => "aidanc1aidan"
}
http = Net::HTTP.new(ENV['GITLAB_ADDRESS'], ENV['GITLAB_PORT'])
res = http.post("/api/v3/users?private_token=#{privateToken}", payload.to_json, headers)
puts res
