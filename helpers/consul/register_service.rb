require 'json'
require_relative 'connection'

parameters = JSON.parse(ARGV[0])

listener = parameters['listener']
checkPath = parameters['checkPath']

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

# check = { "http" => "http://#{address}:#{port}#{checkPath}" , "interval" => "10s", "timeout" => "1s" }

payload = {
    "Node" => node,
    "Address" => privateAddress,
    "Service" => {
        "ID" => serviceId,
        "Service" => serviceId,
        "Tags" => parameters['tags'],
        "Port" => parameters['port'],
        "Address" => address
    }
}

request = Net::HTTP::Put.new("/v1/catalog/register")

res = http.request(request, payload.to_json)

puts res.body

if ( Integer(res.code) != 200 )
    puts res.code
    puts res.body
    raise("Registering service configuration failed")
end
