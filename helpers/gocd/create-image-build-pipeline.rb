require_relative 'builder'
require 'yaml'
require 'canzea/config'

parameters = JSON.parse(ARGV[0])

# blueprint, environment, segment

data = YAML.load(File.read("#{ENV['CATALOG_LOCATION']}/blueprints/#{parameters['blueprint']}/instruction.yml"))

segment = parameters['segment']

if (!data["instructions"]["segments"].has_key?(segment))
    raise("No segment #{segment} found")
end
image = data["instructions"]["segments"][segment]['image']

provision = data["instructions"]["segments"][segment]['provision']
abbrev = data["instructions"]["segments"][segment]['abbreviation']

base = "#{parameters['environment']}-#{parameters['segment']}"

parameters['pipeline'] = "Image-#{base}-BUILD"
parameters['group'] = "Images"

params = {
    "base"=>base,
    "instances"=>"1",
    "fingerprint"=>"96:4a:8d:f4:fb:b9:b9:46:e9:d2:96:38:f2:1a:dc:f5",
    "region"=>provision['region'],
    "size"=>provision['size'],
    "image"=>provision['image'],
    "tags"=>[abbrev,"canzea"]
}

params = JSON.generate(params)
params = params.gsub('"', "\\\"")

params2 = {
    "metadata"=>"provision-#{base}-active.json"
}

params2 = JSON.generate(params2)
params2 = params2.gsub('"', "\\\"")

params3 = {"privateKey"=>"/var/go/.ssh/id_rsa_digitalocean","base"=>base,"instances"=>1}
params3 = JSON.generate(params3).gsub('"', "\\\"")

params4 = JSON.generate({"base"=>base,"instances"=>1}).gsub('"', "\\\"")

prepBuildDef = Array.new
image.each { | key |
    if (key.start_with?("step:"))
        puts key
        aDetail = key.split(':')
        buildDef = {"role"=>aDetail[1],"solution"=>aDetail[2]}
        prepBuildDef.push(buildDef)
    end
}

Builder.new(parameters)
    .base("pipeline-image")
    .required(["CONSUL_URL","VAULT_TOKEN"], ["environment", "segment"])
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
        .append("tasks", "task-canzea-helper", {"solution" => "digitalocean", "action" => "consul-update-images", "parameters" => params4 })
    .add("pipeline.stages", "stage", {"name"=>"Teardown"})
        .append("jobs", "job")
        .append("tasks", "task-canzea-helper", {"solution" => "digitalocean", "action" => "teardown", "parameters" => params4 })
    .save("#{Canzea::config[:pwd]}/pipelines-#{parameters['pipeline']}.json")
