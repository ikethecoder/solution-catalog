# ruby helpers/helper-run.rb rocketchat collaboration-new-channel '{"name":"test5"}'
require 'json'
require 'net/http'
parameters = JSON.parse(ARGV[0])

flow_id = parameters['flow_id']
out_file = parameters['out_file']

# Get the authtoken and userId
uri = URI(ENV['NODERED_URL'] + '/admin/auth/token')

res = Net::HTTP.post_form(uri , 'client_id' => 'node-red-admin', 'grant_type' => 'password', 'scope' => '*', 'username' => 'admin', 'password' => 'password')

data = JSON.parse(res.body)

authToken = data['access_token']

headers = {
  'Authorization' => "Bearer #{authToken}"
}

uri = URI(ENV['NODERED_URL'] + "/admin/flow/#{flow_id}")

http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true

res = http.get("#{uri.path}", headers)

if ( Integer(res.code) != 200 )
    puts res.code
    puts res.body
    raise("Connection to NodeRed Failed")
end

content = JSON.parse(res.body)
if (parameters.has_key? 'out_file')
    File.write(out_file, JSON.pretty_generate(content))
else
    puts JSON.generate(content)
end
