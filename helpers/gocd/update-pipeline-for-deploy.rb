require 'json'
require 'net/http'
require 'template-runner'

parameters = JSON.parse(ARGV[0])

qualifier = parameters['qualifier']

attributes = parameters

branch = attributes['branch']
project = attributes['name']
version = attributes['version']

pattern = attributes[qualifier]['pattern']
pipelinePrefix = attributes[qualifier]['name']

# project: "hello-world-svc-app"
# version: 1.0.0
# pattern: Build, Deploy

attributes['CONSUL_URL'] = ENV['CONSUL_URL']

attributes['project'] = "#{project}"
attributes['group'] = "#{project}"
attributes['pipeline'] = "#{pipelinePrefix}"

t = Template.new

stageTemplate = "helpers/gocd/pipelines/fragment/stage.json"
jobTemplate = "helpers/gocd/pipelines/fragment/job.json"
taskTemplate1 = "helpers/gocd/pipelines/fragment/task-fetch.json"
taskTemplate2 = "helpers/gocd/pipelines/fragment/task-docker-canzea.json"
taskTemplate3 = "helpers/gocd/pipelines/fragment/task-sudo-register-service.json"

root = JSON.parse(t.process "helpers/gocd/pipelines/fragment/pipeline.json", attributes)

material = JSON.parse(t.process "helpers/gocd/pipelines/fragment/material-pipeline.json", attributes)
root['pipeline']['materials'].push (material)

# material = JSON.parse(t.process "helpers/gocd/pipelines/fragment/material-environment.json", attributes)
# root['pipeline']['materials'].push (material)


stage = JSON.parse(t.process stageTemplate, {"name" => "Deploy"})

job = JSON.parse(t.process jobTemplate, attributes)

task = JSON.parse(t.process taskTemplate1, {"project" => project, "version" => version})
job['tasks'].push (task)

params = { "port" => attributes['port'], "env" => attributes['env'], "name" => attributes['name'] }
params = params.to_json.to_json
params = params.slice(1,params.length - 2)

task = JSON.parse(t.process taskTemplate2, {"workingdir" => "", "docker_image" => "canzea/canzea_cli", "project" => project, "version" => version, "solution" => "application", "action" => "install-app", "parameters" => params })
job['tasks'].push (task)

task = JSON.parse(t.process taskTemplate3, {"workingdir" => "", "project" => "#{project}", "service" => "/opt/applications/#{project}-#{branch}.service" })
job['tasks'].push (task)

# params = { "channel" => "integration", "message" => "#{project} deployed" }
# task = JSON.parse(t.process taskTemplate2, {"workingdir" => "", "project" => project, "version" => version, "solution" => "rocketchat", "action" => "collaboration-send-message", "parameters" => JSON.generate(params.to_json) })
# job['tasks'].push (task)

stage['jobs'].push(job)

root['pipeline']['stages'].push (stage)

output = JSON.pretty_generate( root)

File.write("pipelines-#{attributes['pipeline']}.json", output)
