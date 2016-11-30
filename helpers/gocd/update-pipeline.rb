require 'json'
require 'net/http'
require_relative '../../init/template-runner'

parameters = JSON.parse(ARGV[0])

attributes = parameters['data']

project = attributes['project']
version = attributes['version']
pattern = attributes['pattern']

# project: "hello-world-svc-app"
# version: 1.0.0
# pattern: Build, Deploy

attributes['group'] = "#{project}"
attributes['pipeline'] = "#{project}-#{version}-#{pattern}"

t = Template.new

stageTemplate = "helpers/gocd/pipelines/fragment/stage.json"
jobTemplate = "helpers/gocd/pipelines/fragment/job.json"
taskTemplate1 = "helpers/gocd/pipelines/fragment/task-mvn-install.json"
taskTemplate2 = "helpers/gocd/pipelines/fragment/task-ruby.json"

root = JSON.parse(t.process "helpers/gocd/pipelines/fragment/pipeline.json", attributes)

material = JSON.parse(t.process "helpers/gocd/pipelines/fragment/material.json", attributes)
root['pipeline']['materials'].push (material)

material = JSON.parse(t.process "helpers/gocd/pipelines/fragment/material-environment.json", attributes)
root['pipeline']['materials'].push (material)


stage = JSON.parse(t.process stageTemplate, {"name" => "Build"})

job = JSON.parse(t.process jobTemplate, attributes)

task = JSON.parse(t.process taskTemplate1, {"project" => attributes['project']})
job['tasks'].push (task)

params = { "name" => "Joe" }
task = JSON.parse(t.process taskTemplate2, {"project" => attributes['project'], "solution" => "sample", "action" => "info", "parameters" => JSON.generate(params.to_json) })
job['tasks'].push (task)

stage['jobs'].push(job)

root['pipeline']['stages'].push (stage)

output = JSON.pretty_generate( root)

File.write("pipelines-#{attributes['pipeline']}.json", output)
