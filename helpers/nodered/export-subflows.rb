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

uri = URI(ENV['NODERED_URL'] + '/admin/nodes')

http = Net::HTTP.new(uri.host, uri.port)
#http.use_ssl = true

res = http.get("#{uri.path}", headers)

if ( Integer(res.code) != 200 )
    puts res.body
    raise("Connection to NodeRed Failed")
end

content = JSON.parse(res.body)
content['flows'].push({"type" => "tab", "id" => "global"})

content['flows'].each do | flow |
    puts "NODE: #{flow.to_s}"

    if (flow['type'] == 'subflow')
        uri = URI(ENV['NODERED_URL'] + "/admin/node/#{flow['id']}")

        http = Net::HTTP.new(uri.host, uri.port)
        #http.use_ssl = true

        res = http.get("#{uri.path}", headers)

        if ( Integer(res.code) != 200 )
            puts res.code
            puts res.body
            raise("Connection to NodeRed Failed")
        end

        content = JSON.parse(res.body)
        outFile = "sf-#{flow['id']}.flow"
        puts "Writing flow to #{outFile}"
        File.write(outFile, JSON.pretty_generate(content))
    end
end
