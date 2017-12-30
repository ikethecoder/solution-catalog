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

        taskTemplateCanzea = getFragmentPath("task-canzea.json")

        if (type == "java-maven")
            stage = JSON.parse(t.process stageTemplate, {"name" => "Build"})

            job = JSON.parse(t.process jobTemplate, attributes)
            stage['jobs'].push(job)

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

        end

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
        return [
        ]
    end

end

