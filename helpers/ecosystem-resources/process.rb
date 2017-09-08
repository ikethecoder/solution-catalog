
require 'git'
require 'json'

parameters = JSON.parse(ARGV[0])

fileList = parameters['files']

# Open up the list of resource files and run them one by one, calling the Gateway

# The gateway itself will need to be configured appropriately

# There may be special steps needed to interact with the service via the UI, rather than the API.

# The results will be logged by the Gateway


payload = {
    "resources": []
}

headers = {
  'Authorization' => "Bearer #{ENV['NODERED_CANZEA_CONSOLE_TOKEN']}",
  'Node-RED-API-Version' => 'v2',
  'Content-Type' => 'application/json'
}

uri = URI(ENV['NODERED_URL'] + '/api/bulk')

http = Net::HTTP.new(uri.host, uri.port)
#http.use_ssl = true

res = http.post("#{uri.path}", headers, payload)

if ( Integer(res.code) != 200 )
    puts res.body
    raise("Connection to NodeRed Failed")
end

content = JSON.parse(res.body)

puts content
