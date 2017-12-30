require 'json'
require 'commands/push-config'
require 'template-runner'
require_relative 'pipelines/java-maven-build'
require_relative 'pipelines/js-npm-build'
require_relative 'pipelines/hugo-build'
require_relative 'pipelines/deploy'
require_relative 'pipelines/mkdocs-build'

#   PrepareEnvironment.new.addToEnv "#{ENV['CATALOG_LOCATION']}/helpers/config_writers/pipeline_pipeline_env.json"

is_plus = (ARGV[1] == 'PLUS')

t = Template.new
pc = PushConfig.new "/"

if ARGV[0].start_with? "@"
    params = JSON.parse(File.read(ARGV[0][1,100]))
else
    params = JSON.parse(ARGV[0])
end

resourceId = params.keys[0]
properties = params[resourceId]
properties['rid'] = resourceId;
properties['pipelineName'] = resourceId;

puts "PROCESSING...#{resourceId}"

puts "PATTERN = #{properties['pipelineType']}"
puts "TYPE = #{properties['type']}"
if is_plus

    if properties['pipelineType'] == 'deploy'
        output = Deploy.new.createPipeline properties
        handler = Deploy.new
    elsif properties['type'] == 'static-hugo'
        output = HugoBuild.new.createPipeline properties
        handler = HugoBuild.new
    elsif properties['type'] == 'static-mkdocs'
        output = MkdocsBuild.new.createPipeline properties
        handler = MkdocsBuild.new
    elsif properties['type'] == 'java-maven'
        output = JavaMavenBuild.new.createPipeline properties
        handler = JavaMavenBuild.new
    elsif properties['type'] == 'js-npm'
        output = JSNpmBuild.new.createPipeline properties
        handler = JSNpmBuild.new
    else
        raise("unsupported type #{properties['type']}.")
    end
    puts "WRITING : es_orchestrator/pipeline_pipeline/#{resourceId}.json"
    pc.write "es_orchestrator/pipeline_pipeline/#{resourceId}.json", output

    fileList = handler.preparePipelineScripts properties
    fileList.each do | file |
        pc.write file.file, file.content
    end
else
    pc.backupAndRemove "es_orchestrator/pipeline_pipeline/#{resourceId}.json"
end
