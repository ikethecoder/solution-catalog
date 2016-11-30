# ruby helpers/helper-run.rb  gocd import-pipeline '{"pipeline":"hello-world-svc-app"}'

require 'json'
require 'net/http'
parameters = JSON.parse(ARGV[0])

qualifier = parameters['qualifier']

pipeline = parameters[qualifier]['name']

headers = {
  'Confirm' => 'true'
}

http = Net::HTTP.new(ENV['GOCD_ADDRESS'], ENV['GOCD_PORT'])
res = http.post("/go/api/pipelines/#{pipeline}/schedule", "", headers)

if ( Integer(res.code) != 202 )
    puts res.body
    raise("Scheduling pipeline failed")
end
