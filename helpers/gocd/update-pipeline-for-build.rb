require 'json'
require 'net/http'
require 'template-runner'

parameters = JSON.parse(ARGV[0])

qualifier = parameters['qualifier']

attributes = parameters

project = attributes['name']
version = attributes['version']
pattern = attributes[qualifier]['pattern']
pipelinePrefix = attributes[qualifier]['name']

# project: "hello-world-svc-app"
# version: 1.0.0
# pattern: Build, Deploy

attributes['project'] = "#{project}"
attributes['group'] = "#{project}"
attributes['pipeline'] = "#{pipelinePrefix}"

t = Template.new

stageTemplate = "helpers/gocd/pipelines/fragment/stage.json"
jobTemplate = "helpers/gocd/pipelines/fragment/job.json"
artifactTemplate = "helpers/gocd/pipelines/fragment/artifact.json"
taskTemplate1 = "helpers/gocd/pipelines/fragment/task-mvn-install.json"
taskTemplate2 = "helpers/gocd/pipelines/fragment/task-mvn-deploy.json"
taskTemplate3 = "helpers/gocd/pipelines/fragment/task-canzea.json"

root = JSON.parse(t.process "helpers/gocd/pipelines/fragment/pipeline.json", attributes)

material = JSON.parse(t.process "helpers/gocd/pipelines/fragment/material.json", attributes)
root['pipeline']['materials'].push (material)

# material = JSON.parse(t.process "helpers/gocd/pipelines/fragment/material-environment.json", attributes)
# root['pipeline']['materials'].push (material)


stage = JSON.parse(t.process stageTemplate, {"name" => "Build"})

job = JSON.parse(t.process jobTemplate, attributes)

task = JSON.parse(t.process taskTemplate1, {"project" => attributes['project']})
job['tasks'].push (task)

task = JSON.parse(t.process taskTemplate2, {"project" => attributes['project']})
job['tasks'].push (task)

params = { "ecosystem" => "XXXXX" }
task = JSON.parse(t.process taskTemplate3, {"project" => attributes['project'], "solution" => "sample", "action" => "info", "parameters" => JSON.generate(params.to_json) })
job['tasks'].push (task)

if (attributes.has_key? "module")
    artifact = JSON.parse(t.process artifactTemplate, attributes)
    job['artifacts'].push (artifact)
end

stage['jobs'].push(job)

root['pipeline']['stages'].push (stage)

output = JSON.pretty_generate( root)

File.write("pipelines-#{attributes['pipeline']}.json", output)
