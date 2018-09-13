# ruby helpers/helper-run.rb  gocd get-object '{"qualifier":"A","A":{"type":"environments","Integration":""}}'

require 'json'
require 'net/http'

parameters = JSON.parse(ARGV[0])

qualifier = parameters['qualifier']

# Type: environments, pipelines
type = parameters[qualifier]['type']
name = parameters[qualifier]['name']
version = parameters[qualifier]['version']

require_relative './gocd-client.rb'
cli = GoCDClient.new

headers = cli.headers(version)

http = Net::HTTP.new(ENV['GOCD_ADDRESS'], ENV['GOCD_PORT'])
http.use_ssl = false
res = http.get("/go/api/admin/#{type}/#{name}", headers)

if ( Integer(res.code) != 200 )
    puts res.body
    raise("Getting #{type} #{name} failed")
end

File.write("#{type}-#{name}.json", res.body)
File.write("#{type}-#{name}-etag.txt", res['ETag'])
