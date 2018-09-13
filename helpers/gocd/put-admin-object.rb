# ruby helpers/helper-run.rb  gocd put-object '{"qualifier":"A","A":{"type":"environments","name":"Build"}}'

require 'json'
require 'net/http'
parameters = JSON.parse(ARGV[0])

qualifier = parameters['qualifier']

type = parameters[qualifier]['type']
name = parameters[qualifier]['name']

file = File.open("#{type}-#{name}-etag.txt", "rb")
etag = file.read

require_relative './gocd-client.rb'
cli = GoCDClient.new

headers = cli.headers(2)

headers['If-Match'] = etag

file = File.open("#{type}-#{name}.json", "rb")
payload = file.read

http = Net::HTTP.new(ENV['GOCD_ADDRESS'], ENV['GOCD_PORT'])
res = http.put("/go/api/admin/#{type}/#{name}", payload, headers)

if ( Integer(res.code) != 200 )
    puts res.body
    raise("Updating #{type} #{name} failed")
end
