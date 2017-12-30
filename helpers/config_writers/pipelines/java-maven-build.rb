require 'json'
require 'template-runner'

class JavaMavenBuild

    def createPipeline (parameters)

        attributes = parameters

        type = attributes['type']

        project = attributes['name']
        version = attributes['version']
        pattern = attributes['pattern']

        attributes['project'] = "#{project}"
        attributes['group'] = "#{project}"

        t = Template.new

        stageTemplate = getFragmentPath("stage.json")

        jobTemplate = getFragmentPath("job.json")

        root = JSON.parse(t.process getFragmentPath("pipeline.json"), attributes)

        material = JSON.parse(t.process getFragmentPath("material.json"), attributes)
        root['pipeline']['materials'].push (material)

        material = JSON.parse(t.process getFragmentPath("material.json"), {"url"=>"https://#{ENV['ECOSYSTEM']}.canzea.cc/gogs/root/ecosystems.git","name"=>"es-catalog","branch"=>"master"})
        root['pipeline']['materials'].push (material)

        taskTemplateCanzea = getFragmentPath("task-canzea.json")

        stage = JSON.parse(t.process stageTemplate, {"name" => "Build"})

        job = JSON.parse(t.process jobTemplate, attributes)
        stage['jobs'].push(job)

        taskTemplate1 = getFragmentPath("task-docker-cli.json")
        taskTemplate2 = getFragmentPath("task-docker.json")

        task = JSON.parse(t.process taskTemplate1, {"workdir" => "es-catalog/ecosystems/#{ENV['ECOSYSTEM']}/components/#{attributes['project']}", "arguments" => ["build", "--tag", "#{project}-task", "."] })
        job['tasks'].push (task)

        task = JSON.parse(t.process taskTemplate2, {"project" => attributes['project'], "arguments" => ["#{project}-task", "mvn", "clean", "install"] })
        job['tasks'].push (task)


        taskTemplate1 = getFragmentPath("task-docker-mvn-install.json")
        taskTemplate2 = getFragmentPath("task-mvn-deploy.json")
        artifactTemplate = getFragmentPath("artifact.json")

        task = JSON.parse(t.process taskTemplate1, {"project" => attributes['project']})
        job['tasks'].push (task)

        task = JSON.parse(t.process taskTemplate2, {"project" => attributes['project']})
        job['tasks'].push (task)

        if (attributes.has_key? "module")
            attributes['projectModule'] = "#{project}/#{attributes['module']}"
        else
            attributes['projectModule'] = "#{project}"
        end
        artifact = JSON.parse(t.process artifactTemplate, attributes)
        job['artifacts'].push (artifact)

        root['pipeline']['stages'].push (stage)

        item = {
            "pipeline_pipeline" => {
                attributes['rid'] => root
            }
        }
        return JSON.pretty_generate( item )
    end

    def getFragmentPath (fileRelativePath)
        return "#{ENV['CATALOG_LOCATION']}/helpers/config_writers/pipelines/fragment/#{fileRelativePath}"
    end

    def preparePipelineScripts(parameters)
        project = parameters['name']
        dockerFile = File.read("#{ENV['CATALOG_LOCATION']}/helpers/config_writers/pipelines/commands/maven.script")

        return [
            { "file" => "components/#{project}/Dockerfile", "content" => dockerFile }
        ]
    end

end

