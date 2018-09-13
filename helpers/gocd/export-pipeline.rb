# ruby helpers/helper-run.rb  gocd export-pipeline '{"pipeline":"hello-world-svc-app"}'

require 'json'
require 'net/http'
parameters = JSON.parse(ARGV[0])

pipeline = parameters['pipeline']

require_relative './gocd-client.rb'
cli = GoCDClient.new

headers = cli.headers(2)

http = Net::HTTP.new(ENV['GOCD_ADDRESS'], ENV['GOCD_PORT'])
http.use_ssl = false
res = http.get("/go/api/admin/pipelines/#{pipeline}", headers)

file = File.open("#{pipeline}.json", File::CREAT|File::RDWR)
file.write(res.body)

file = File.open("#{pipeline}-etag.txt", File::CREAT|File::RDWR)
file.write(res['ETag'])

