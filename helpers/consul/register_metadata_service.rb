require 'json'
require 'template-runner'
require_relative 'connection'

parameters = JSON.parse(ARGV[0])

file = parameters['metadata']

metadata = JSON.parse(File.read(file))

metadata.services.each do | service |

    listener = service['listener']

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

    serviceId = "#{service['id']}"
    serviceName = "#{service['name']}"

    # check = { "http" => "http://#{address}:#{port}#{checkPath}" , "interval" => "10s", "timeout" => "1s" }

    port = service['port']

    payload = {
        "ID" => serviceId,
        "Name" => serviceName,
        "Tags" => service['tags'],
        "Port" => port,
        "Address" => address
    }


    if (service.has_key? "check")
        if (service['check'].has_key? "path")
            service['check']['http'] = "http://#{address}:#{port}#{service['check']['path']}"
        end
        service['check']['http'] = Template.new.processString service['check']['http'] { "address" : "http://#{address}:#{port}" }
        payload[:Check] = service['check']
    end

    request = Net::HTTP::Put.new("/v1/agent/service/register")

    res = http.request(request, payload.to_json)

    puts res.body

    if ( Integer(res.code) != 200 )
        puts res.code
        puts res.body
        raise("Registering service configuration failed")
    end
end
