# ruby helpers/helper-run.rb  gocd get-object '{"qualifier":"A","A":{"type":"environments","Integration":""}}'

require 'json'
require 'net/http'
parameters = JSON.parse(ARGV[0])

qualifier = parameters['qualifier']

# Type: environments, pipelines
type = parameters[qualifier]['type']
name = parameters[qualifier]['name']

headers = {
  'Accept' => 'application/vnd.go.cd.v2+json',
  'Content-Type' => 'application/json'
}

http = Net::HTTP.new(ENV['GOCD_ADDRESS'], ENV['GOCD_PORT'])
http.use_ssl = false
res = http.get("/go/api/admin/#{type}/#{name}", headers)

if ( Integer(res.code) != 200 )
    puts res.body
    raise("Getting #{type} #{name} failed")
end

File.write("#{type}-#{name}.json", res.body)
File.write("#{type}-#{name}-etag.txt", res['ETag'])
