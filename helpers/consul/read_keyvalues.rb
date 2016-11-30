# ruby read_keyvalue.rb '{"key":"nodes"}'

require 'json'
require 'net/http'
require 'base64'

parameters = JSON.parse(ARGV[0])

key = parameters['key']

# Get the authtoken and userId
uri = URI(ENV['CONSUL_URL'])

headers = {
}

http = Net::HTTP.new(uri.host, uri.port)
res = http.get("/v1/kv/#{key}?recurse=true", headers)
if ( Integer(res.code) != 200 )
    puts "Return code #{res.code}"
    puts res.body
    raise("Adding key value configuration failed")
else
    response = []
    result = JSON.parse(res.body)
    result.each() do |item|
      response.push({item["Key"] => Base64.decode64(item["Value"])})
    end
    puts JSON.generate(response)
end
