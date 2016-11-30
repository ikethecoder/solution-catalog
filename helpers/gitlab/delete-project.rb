# ruby helpers/helper-run.rb gitlab delete-project '{"name":"heyworld3","login":"root","password":"admin1admin1"}'

require 'json'
require 'net/http'

parameters = JSON.parse(ARGV[0])

project = parameters['name']

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
}
http = Net::HTTP.new(ENV['GITLAB_ADDRESS'], ENV['GITLAB_PORT'])

id = ""
res = http.get("/api/v3/projects/all?private_token=#{privateToken}", headers)
JSON.parse(res.body).each do | item |
   if (item['name'] == project)
      id = item['id']
   end
end

res = http.delete("/api/v3/projects/#{id}?private_token=#{privateToken}", headers)
if ( Integer(res.code) != 200 )
    puts res.body
    raise("Removing project failed")
end