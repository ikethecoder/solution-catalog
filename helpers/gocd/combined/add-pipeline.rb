require 'json'
require 'net/http'
require 'template-runner'
require_relative '../gocd-client'

parameters = JSON.parse(ARGV[0])

qualifier = parameters['qualifier']

attributes = parameters

type = attributes['type']
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

root = JSON.parse(t.process "helpers/gocd/pipelines/fragment/pipeline.json", attributes)

material = JSON.parse(t.process "helpers/gocd/pipelines/fragment/material.json", attributes)
root['pipeline']['materials'].push (material)

# material = JSON.parse(t.process "helpers/gocd/pipelines/fragment/material-environment.json", attributes)
# root['pipeline']['materials'].push (material)

taskTemplateCanzea = "helpers/gocd/pipelines/fragment/task-canzea.json"


if (type == "java-maven")
    stage = JSON.parse(t.process stageTemplate, {"name" => "Build"})

    job = JSON.parse(t.process jobTemplate, attributes)
    stage['jobs'].push(job)

    taskTemplate1 = "helpers/gocd/pipelines/fragment/task-mvn-install.json"
    taskTemplate2 = "helpers/gocd/pipelines/fragment/task-mvn-deploy.json"
    artifactTemplate = "helpers/gocd/pipelines/fragment/artifact.json"

    task = JSON.parse(t.process taskTemplate1, {"project" => attributes['project']})
    job['tasks'].push (task)

    task = JSON.parse(t.process taskTemplate2, {"project" => attributes['project']})
    job['tasks'].push (task)

    params = { "ecosystem" => "XXXXX" }
    params = JSON.generate(params.to_json)
    params = params.slice(1,params.length - 2)

    task = JSON.parse(t.process taskTemplateCanzea, {"project" => attributes['project'], "solution" => "sample", "action" => "info", "parameters" => params })
    job['tasks'].push (task)


    if (attributes.has_key? "module")
        attributes['projectModule'] = "#{project}/#{attributes['module']}"
    else
        attributes['projectModule'] = "#{project}"
    end
    artifact = JSON.parse(t.process artifactTemplate, attributes)
    job['artifacts'].push (artifact)

    root['pipeline']['stages'].push (stage)

end
if (type == "js-npm")
    stage = JSON.parse(t.process stageTemplate, {"name" => "Build"})

    job = JSON.parse(t.process jobTemplate, attributes)
    stage['jobs'].push(job)

    taskTemplate1 = "helpers/gocd/pipelines/fragment/task-npm.json"
    taskTemplate2 = "helpers/gocd/pipelines/fragment/task-bower.json"

    task = JSON.parse(t.process taskTemplate1, {"project" => attributes['project'], "arguments" => ["config", "set", "jobs", "1"] })
    job['tasks'].push (task)

    task = JSON.parse(t.process taskTemplate1, {"project" => attributes['project'], "arguments" => ["install"] })
    job['tasks'].push (task)

    task = JSON.parse(t.process taskTemplate1, {"project" => attributes['project'], "arguments" => ["install", "bower"] })
    job['tasks'].push (task)

    task = JSON.parse(t.process taskTemplate2, {"project" => attributes['project'], "arguments" => ["install"] })
    job['tasks'].push (task)

    task = JSON.parse(t.process taskTemplate1, {"project" => attributes['project'], "arguments" => ["run", "build"] })
    job['tasks'].push (task)

    root['pipeline']['stages'].push (stage)


    stage = JSON.parse(t.process stageTemplate, {"name" => "Registry"})

    job = JSON.parse(t.process jobTemplate, attributes)
    stage['jobs'].push(job)

    params = { }
    params = JSON.generate(params.to_json)
    params = params.slice(1,params.length - 2)

    task = JSON.parse(t.process taskTemplateCanzea, {"project" => attributes['project'], "solution" => "gocd", "action" => "prep-build", "parameters" => params })
    job['tasks'].push (task)

    taskTemplate = "helpers/gocd/pipelines/fragment/task-mvn-package.json"
    task = JSON.parse(t.process taskTemplate, {"project" => attributes['project']})
    job['tasks'].push (task)

    taskTemplate = "helpers/gocd/pipelines/fragment/task-mvn-deploy.json"
    task = JSON.parse(t.process taskTemplate, {"project" => attributes['project']})
    job['tasks'].push (task)

    root['pipeline']['stages'].push (stage)

end



output = JSON.pretty_generate( root)

File.write("pipelines-#{attributes['pipeline']}.json", output)

pipelineName = parameters['name']

cli = GoCDClient.new '/go/api/admin'


cli.postObject '4', 'pipelines', attributes['pipeline'], output
