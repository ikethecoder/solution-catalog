require_relative 'builder'

parameters = JSON.parse(ARGV[0])

parameters['pipeline'] = "Image-#{parameters['environment']}-#{parameters['segment']}-BUILD"
parameters['group'] = "Images"

base = "#{parameters['environment']}-#{parameters['segment']}"

buildDefinition = JSON.parse(File.read("environment_#{base}.json"))

provision = buildDefinition[0]['arguments']

params = {
    "base"=>base,
    "instances"=>"1",
    "fingerprint"=>"96:4a:8d:f4:fb:b9:b9:46:e9:d2:96:38:f2:1a:dc:f5",
    "region"=>"nyc1",
    "size"=>"2gb",
    "image"=>provision['image']
}

params = JSON.generate(params)
params = params.gsub('"', "\\\"")

params2 = {
    "metadata"=>"digital-ocean-instances-final2.json"
}

params2 = JSON.generate(params2)
params2 = params2.gsub('"', "\\\"")

params3 = {"privateKey"=>"/var/go/.ssh/id_rsa_digitalocean","base"=>base,"instances"=>1}
params3 = JSON.generate(params3).gsub('"', "\\\"")

params4 = JSON.generate({"base"=>base,"instances"=>1}).gsub('"', "\\\"")


prepBuildDef = Array.new
buildDefinition.each { | b |
    if b['activity'].start_with?("step:") or b['activity'].start_with?("service:")
        aDetail = b['activity'].split(':')
        buildDef = {"role"=>aDetail[1],"solution"=>aDetail[2]}
        prepBuildDef.push(buildDef)
    end
}

Builder.new(parameters)
    .base("pipeline-image")
    .required(["CONSUL_URL","VAULT_TOKEN"], ["environment", "segment", "pattern"])
    .add("pipeline.materials", "material-environment")
    .add("pipeline.stages", "stage-first", {"name"=>"Provision"})
        .append("jobs", "job")
        .appendAll([
            ["tasks", "task-canzea-helper", {"solution" => "digitalocean", "action" => "expand", "args" => params }],
            ["tasks", "task-canzea-helper", {"solution" => "digitalocean", "action" => "consul-update", "args" => params2 }]])
    .add("pipeline.stages", "stage", {"name"=>"Health-Check"})
        .append("jobs", "job")
        .append("tasks", "task-canzea-helper", {"solution" => "digitalocean", "action" => "health-check", "args" => params3 })
    .add("pipeline.stages", "stage", {"name"=>"Bootstrap"})
        .append("jobs", "job")
        .appendAll([
            ["tasks", "task-canzea-helper", {"solution" => "digitalocean", "action" => "set-public-ip", "args" => params4 }],
            ["tasks", "task-canzea-init", {"base" => base, "serverNumber" => 1 }]])
    .forEach(prepBuildDef)
        .add("pipeline.stages", "stage", {"name"=>"{{role}}.{{solution}}"})
        .append("jobs", "job")
        .append("tasks", "task-canzea-remote", {"base" => base, "serverNumber" => 1, "role" => "{{role}}", "solution" => "{{solution}}" })
        .end()
    .add("pipeline.stages", "stage", {"name"=>"Image"})
        .append("jobs", "job")
        .append("tasks", "task-canzea-helper", {"solution" => "digitalocean", "action" => "image", "parameters" => params4 })
    .add("pipeline.stages", "stage", {"name"=>"Teardown"})
        .append("jobs", "job")
        .append("tasks", "task-canzea-helper", {"solution" => "digitalocean", "action" => "teardown", "parameters" => params4 })
    .save("pipelines-#{parameters['pipeline']}.json")


if false
    attributes = parameters

    # ["environment", "segment", "pattern", "defFile"]

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
    taskTemplate2 = "helpers/gocd/pipelines/fragment/task-ruby.json"

    root = JSON.parse(t.process "helpers/gocd/pipelines/fragment/pipeline.json", attributes)

    material = JSON.parse(t.process "helpers/gocd/pipelines/fragment/material-pipeline.json", attributes)
    root['pipeline']['materials'].push (material)

    material = JSON.parse(t.process "helpers/gocd/pipelines/fragment/material-environment.json", attributes)
    root['pipeline']['materials'].push (material)


    stage = JSON.parse(t.process stageTemplate, {"name" => "Deploy"})

    job = JSON.parse(t.process jobTemplate, attributes)

    task = JSON.parse(t.process taskTemplate1, {"project" => project, "version" => version})
    job['tasks'].push (task)

    params = { "port" => attributes['port'], "name" => attributes['name'] }
    task = JSON.parse(t.process taskTemplate2, {"project" => project, "version" => version, "solution" => "application", "action" => "install-app", "parameters" => JSON.generate(params.to_json) })
    job['tasks'].push (task)

    params = { "channel" => "integration", "message" => "#{project} deployed" }
    task = JSON.parse(t.process taskTemplate2, {"project" => project, "version" => version, "solution" => "rocketchat", "action" => "collaboration-send-message", "parameters" => JSON.generate(params.to_json) })
    job['tasks'].push (task)

    stage['jobs'].push(job)

    root['pipeline']['stages'].push (stage)

    output = JSON.pretty_generate( root)

    File.write("pipelines-#{attributes['pipeline']}.json", output)
end