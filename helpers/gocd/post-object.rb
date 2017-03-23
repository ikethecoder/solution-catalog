# ruby helpers/helper-run.rb  gocd import-pipeline '{"pipeline":"hello-world-svc-app"}'
# ruby helpers/helper-run.rb  gocd post-object '{"type":"environments", "name":"Integration"}'

require 'json'
require 'net/http'
require 'canzea/config'

parameters = JSON.parse(ARGV[0])

# Type: environments, pipelines

qualifier = parameters.has_key?('qualifier') ? parameters['qualifier']:"N/A"

# Type: environments, pipelines

if (qualifier == "N/A")
    type = parameters['type']
    name = parameters['name']
else
    type = parameters[qualifier]['type']
    name = parameters[qualifier]['name']
end


headers = {
  'Accept' => 'application/vnd.go.cd.v3+json',
  'Content-Type' => 'application/json',
}

file = File.open("#{Canzea::config[:pwd]}/#{type}-#{name}.json", "rb")
payload = file.read

http = Net::HTTP.new(ENV['GOCD_ADDRESS'], ENV['GOCD_PORT'])
res = http.post("/go/api/admin/#{type}", payload, headers)

if ( Integer(res.code) != 200 )
    puts res.body
    raise("Creation of #{type} #{name} failed")
end
