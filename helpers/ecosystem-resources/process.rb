
require 'git'
require 'json'
require 'net/http'
require 'uri'

parameters = JSON.parse(ARGV[0])

fileList = parameters['files']

# Open up the list of resource files and run them one by one, calling the Gateway

# The gateway itself will need to be configured appropriately

# There may be special steps needed to interact with the service via the UI, rather than the API.

# The results will be logged by the Gateway

files.each do | file |

    data = File.read(file)

    payload = JSON.parse(data)

    headers = {
      'Authorization' => "Bearer #{ENV['NODERED_CANZEA_CONSOLE_TOKEN']}",
      'Node-RED-API-Version' => 'v2',
      'Content-Type' => 'application/json'
    }

    uri = URI(ENV['NODERED_URL'] + '/api/bulk')

    http = Net::HTTP.new(uri.host, uri.port)
    #http.use_ssl = true

    res = http.post("#{uri.path}", payload.to_json, headers)

    if ( Integer(res.code) >= 300 )
        puts res.body
        raise("Connection to NodeRed Failed")
    end

    # content = JSON.parse(res.body)

    # puts content
end
