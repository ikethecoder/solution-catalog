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
#http.use_ssl = true

res = http.get("#{uri.path}", headers)

if ( Integer(res.code) != 200 )
    puts res.body
    raise("Connection to NodeRed Failed")
end

def clean (a)
    a = a.clone
    a.gsub!(' / ', '-')
    a.gsub!(' ', '-')
    a.gsub!('_', '-')
    a.gsub!('.', '-')
    return a.downcase
end

content = JSON.parse(res.body)
content['flows'].push({"type" => "tab", "id" => "global"})

content['flows'].each do | flow |
    puts "FLOW: #{flow.to_s}"

    if (flow['type'] == 'tab')
        uri = URI(ENV['NODERED_URL'] + "/admin/flow/#{flow['id']}")

        http = Net::HTTP.new(uri.host, uri.port)
        #http.use_ssl = true

        res = http.get("#{uri.path}", headers)

        if ( Integer(res.code) != 200 )
            puts res.code
            puts res.body
            raise("Connection to NodeRed Failed")
        end

        content = JSON.parse(res.body)
        outFile = "nr-#{flow['type']}-#{clean(flow['label'])}.flow"
        puts "Writing flow to #{outFile}"
        File.write(outFile, JSON.pretty_generate(content))
    else
        outFile = "nf-#{flow['type']}-#{clean(flow['label'])}.flow"
        puts "Writing #{flow['type']} to #{outFile}"
        File.write(outFile, JSON.pretty_generate(flow))
    end

#    if (flow['type'] == 'subflow')
#
#        outFile = "nr-#{flow['type']}-#{flow['id']}.flow"
#        puts "Writing subflow to #{outFile}"
#        File.write(outFile, JSON.pretty_generate(flow))
#    end
#
end
