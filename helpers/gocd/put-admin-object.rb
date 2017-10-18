# ruby helpers/helper-run.rb  gocd put-object '{"qualifier":"A","A":{"type":"environments","name":"Build"}}'

require 'json'
require 'net/http'
parameters = JSON.parse(ARGV[0])

qualifier = parameters['qualifier']

type = parameters[qualifier]['type']
name = parameters[qualifier]['name']

file = File.open("#{type}-#{name}-etag.txt", "rb")
etag = file.read

headers = {
  'Accept' => 'application/vnd.go.cd.v2+json',
  'Content-Type' => 'application/json',
  'If-Match' => etag
}

file = File.open("#{type}-#{name}.json", "rb")
payload = file.read

http = Net::HTTP.new(ENV['GOCD_ADDRESS'], ENV['GOCD_PORT'])
res = http.put("/go/api/admin/#{type}/#{name}", payload, headers)

if ( Integer(res.code) != 200 )
    puts res.body
    raise("Updating #{type} #{name} failed")
end
