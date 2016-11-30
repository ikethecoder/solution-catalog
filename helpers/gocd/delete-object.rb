# ruby helpers/helper-run.rb  gocd delete-object '{"qualifier":"A", "A":{"type":"pipelines","name":"mingle-1.0.0-Deploy"}}'

require 'json'
require 'net/http'
parameters = JSON.parse(ARGV[0])

qualifier = parameters['qualifier']

if (qualifier == "N/A")
    type = parameters['type']
    name = parameters['name']
else
    type = parameters[qualifier]['type']
    name = parameters[qualifier]['name']
end

headers = {
  'Accept' => 'application/vnd.go.cd.v2+json',
  'Content-Type' => 'application/json'
}

http = Net::HTTP.new(ENV['GOCD_ADDRESS'], ENV['GOCD_PORT'])
res = http.delete("/go/api/admin/#{type}/#{name}", headers)

if ( Integer(res.code) != 200 )
    puts res.body
    raise("Deletion of #{type} #{name} failed")
end
