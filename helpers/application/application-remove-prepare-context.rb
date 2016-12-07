require 'json'
require 'net/http'
require 'fileutils'

parameters = JSON.parse(ARGV[0])

# contextId
# environments

# calculate all the contextual variables that are needed to complete this helper
# Any variables that will persist can be retrieved from consul

name = parameters['name']

artifact = JSON.parse(File.read("artifact-#{name}.json"))

projectName = parameters['name']
branch = "master";
version = artifact['version']
pipelinePrefix = projectName + "-" + branch

context = {
  "name" => projectName,
  "targetName" => projectName,
  "version" => version,
  "localUrl" => "#{ENV['GITLAB_URL']}/root/#{projectName}.git",
  "localBranch" => branch,
  "login" => "root",
  "password" => "admin1admin1",
  "build_pipeline" => {"pattern": "Build","type":"pipelines", "name":"#{pipelinePrefix}-Build"},
  "build_environment" => {"type": "environments", "name": "Build", "pipelineName":"#{pipelinePrefix}-Build"},
  "deploy_pipeline" => {"pattern": "Deploy","type":"pipelines", "name":"#{pipelinePrefix}-Deploy"},
  "deploy_environment" => {"type": "environments", "name": "Integration", "pipelineName":"#{pipelinePrefix}-Deploy"},
  "artifact" => artifact
}

FileUtils.mkdir_p(ENV['WORK_DIR'])

File.write(ENV['WORK_DIR'] + "/context.json", JSON.pretty_generate(context))

#raise "Haven't implemented yet!"
