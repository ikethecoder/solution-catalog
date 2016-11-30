
#ruby helpers/helper-run.rb  gocd remove-pipeline-from-environment '{"qualifier":"A","A":{"type":"environments","name":"Build","pipelineName":"mingle2-1.0.0-Build"}}'

require 'json'
require 'net/http'
require_relative '../../init/template-runner'

parameters = JSON.parse(ARGV[0])

qualifier = parameters['qualifier']

type = parameters[qualifier]['type']
name = parameters[qualifier]['name']
pipelineName = parameters[qualifier]['pipelineName']

file = File.open("#{type}-#{name}.json", "rb")
payload = file.read

environments = JSON.parse(payload)

pipes = []
environments['pipelines'].each do | item |
   if (item['name'] != pipelineName)
      pipes.push(item)
   end
end
environments['pipelines'] = pipes

output = JSON.pretty_generate(environments)

File.write("#{type}-#{name}.json", output)
