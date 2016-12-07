require 'json'
require 'net/http'
require 'template-runner'

parameters = JSON.parse(ARGV[0])

qualifier = parameters['qualifier']

type = parameters[qualifier]['type']
name = parameters[qualifier]['name']
pipelineName = parameters[qualifier]['pipelineName']

file = File.open("#{type}-#{name}.json", "rb")
payload = file.read

environments = JSON.parse(payload)

pipeline = { "name" => pipelineName }
environments['pipelines'].push(pipeline)

output = JSON.pretty_generate(environments)

File.write("#{type}-#{name}.json", output)
