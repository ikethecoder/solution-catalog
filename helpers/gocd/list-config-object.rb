# ruby helpers/helper-run.rb  gocd list-config-object '{"qualifier":"A", "A":{"type":"pipeline_groups"}}'


require 'json'
require 'net/http'
parameters = JSON.parse(ARGV[0])

qualifier = parameters['qualifier']

# Type: environments, pipelines
type = parameters[qualifier]['type']

require_relative './gocd-client.rb'
cli = GoCDClient.new

headers = cli.headers(2)

http = Net::HTTP.new(ENV['GOCD_ADDRESS'], ENV['GOCD_PORT'])
http.use_ssl = false
res = http.get("/go/api/config/#{type}", headers)

if ( Integer(res.code) != 200 )
    puts res.body
    raise("Getting #{type} failed")
end

File.write("#{type}.json", res.body)
