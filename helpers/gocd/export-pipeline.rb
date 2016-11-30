# ruby helpers/helper-run.rb  gocd export-pipeline '{"pipeline":"hello-world-svc-app"}'

require 'json'
require 'net/http'
parameters = JSON.parse(ARGV[0])

pipeline = parameters['pipeline']

headers = {
  'Accept' => 'application/vnd.go.cd.v2+json',
  'Content-Type' => 'application/json'
}

http = Net::HTTP.new("localhost",8153)
http.use_ssl = false
res = http.get("/go/api/admin/pipelines/#{pipeline}", headers)

file = File.open("#{pipeline}.json", File::CREAT|File::RDWR)
file.write(res.body)

file = File.open("#{pipeline}-etag.txt", File::CREAT|File::RDWR)
file.write(res['ETag'])

