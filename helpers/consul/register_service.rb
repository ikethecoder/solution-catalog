require 'json'
require_relative 'connection'

parameters = JSON.parse(ARGV[0])

listener = parameters['listener']

http = Connection.new.prepareHttpPutConnection()

node = Net::HTTP.get('169.254.169.254', '/metadata/v1/hostname')

privateAddress = Net::HTTP.get('169.254.169.254', '/metadata/v1/interfaces/private/0/ipv4/address')

if (listener == 'pub')
    address = Net::HTTP.get('169.254.169.254', '/metadata/v1/interfaces/public/0/ipv4/address')
elsif (listener == 'prv')
    address = privateAddress
elsif (listener == 'loc')
    address = "localhost"
end
# -#{node}-#{parameters['port']}
serviceId = "#{parameters['service']}"
serviceName = "#{parameters['name']}"

# check = { "http" => "http://#{address}:#{port}#{checkPath}" , "interval" => "10s", "timeout" => "1s" }

port = parameters['port']

payload = {
    "ID" => serviceId,
    "Name" => serviceName,
    "Tags" => parameters['tags'],
    "Port" => port,
    "Address" => address
}


if (parameters.has_key? "check")
    if (parameters['check'].has_key? "path")
        parameters['check']['http'] = "http://#{address}:#{port}#{parameters['check']['path']}"
    end
    payload[:Check] = parameters['check']
end

request = Net::HTTP::Put.new("/v1/agent/service/register")

res = http.request(request, payload.to_json)

puts res.body

if ( Integer(res.code) != 200 )
    puts res.code
    puts res.body
    raise("Registering service configuration failed")
end
