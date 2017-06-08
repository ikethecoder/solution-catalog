# ruby helpers/helper-run.rb rocketchat collaboration-new-channel '{"name":"test5"}'
require 'json'
require 'net/http'
parameters = JSON.parse(ARGV[0])

flow_id = parameters['flow_id']
out_file = parameters['out_file']

# Get the authtoken and userId
uri = URI(ENV['NODERED_URL'] + '/oauth/token')

res = Net::HTTP.post_form(uri , 'client_id' => 'thom', 'client_secret' => 'nightworld', 'grant_type' => 'password', 'scope' => '*', 'username' => 'thomseddon', 'password' => 'nightworld')

data = JSON.parse(res.body)

authToken = data['access_token']

puts authToken