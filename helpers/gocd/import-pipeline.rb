# ruby helpers/helper-run.rb  gocd import-pipeline '{"pipeline":"hello-world-svc-app"}'

require 'json'
require 'net/http'
parameters = JSON.parse(ARGV[0])

pipeline = parameters['pipeline']

file = File.open("#{pipeline}-etag.txt", "rb")
etag = file.read

headers = {
  'Accept' => 'application/vnd.go.cd.v2+json',
  'Content-Type' => 'application/json',
  'If-Match' => etag
}

file = File.open("#{pipeline}.json", "rb")
payload = file.read

http = Net::HTTP.new(ENV['GOCD_ADDRESS'], ENV['GOCD_PORT'])
res = http.put("/go/api/admin/pipelines/#{pipeline}", payload, headers)

if ( Integer(res.code) != 200 )
    puts res.body
    raise("Importing pipeline failed")
end
