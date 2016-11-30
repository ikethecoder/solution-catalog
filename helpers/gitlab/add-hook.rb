# ruby helpers/helper-run.rb gitlab add_hook '{"project":"hello-world-svc-app", "repo":"http://localhost:90/root/hello-world-svc-app.git", "login":"root","password":"admin1admin1"}'

require 'json'
require 'net/http'

parameters = JSON.parse(ARGV[0])

project = parameters['name']
repo = parameters['localUrl']

# Get the authtoken and userId
uri = URI(ENV['GITLAB_URL'] + '/api/v3/session')

res = Net::HTTP.post_form(uri, 'login' => parameters['login'], 'password' => parameters['password'])

data = JSON.parse(res.body)

privateToken = data['private_token']

# Create User
headers = {
        'Content-Type' => 'application/json'
}
payload = {
        "id" => project,
        "url" => "http://localhost:82/go/api/material/notify/git?repository_url=#{repo}"
}
http = Net::HTTP.new(ENV['GITLAB_ADDRESS'], ENV['GITLAB_PORT'])

id = ""
res = http.get("/api/v3/projects/all?private_token=#{privateToken}", headers)
JSON.parse(res.body).each do | item |
   if (item['name'] == project)
      id = item['id']
   end
end

res = http.post("/api/v3/projects/#{id}/hooks?private_token=#{privateToken}", payload.to_json, headers)

if ( Integer(res.code) != 201 )
    puts res.body
    raise("Adding hook failed")
end
