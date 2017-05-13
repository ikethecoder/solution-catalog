# ruby helpers/helper-run.rb  gocd list-admin-objects '{"qualifier":"A", "A":{"type":"environments","version":1}}'

require 'json'
require 'net/http'
parameters = JSON.parse(ARGV[0])

qualifier = parameters['qualifier']

# Type: environments, pipelines
type = parameters[qualifier]['type']
version = parameters[qualifier]['version']

headers = {
  'Content-Type' => 'application/json',
  'Accept' => "application/vnd.go.cd.v#{version}+json"
}

http = Net::HTTP.new("localhost",8153)
http.use_ssl = false
res = http.get("/go/api/admin/#{type}", headers)

if ( Integer(res.code) != 200 )
    puts res.body
    raise("Getting #{type} failed")
end

File.write("#{type}.json", res.body)
