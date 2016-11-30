require 'json'
require 'registry'
require 'canzea/config'

parameters = JSON.parse(ARGV[0])

r = Registry.new

base=parameters['base']
instances=Integer(parameters['instances'])

for i in 1..instances
    id = i.to_s.rjust(2, '0')

    hostname = r.getValue "nodes/#{base}-#{id}", "public_ip"

    File.open("#{Canzea::config[:pwd]}/vps-#{base}-#{i}.json", 'w') { |file| file.write(hostname) }
end
