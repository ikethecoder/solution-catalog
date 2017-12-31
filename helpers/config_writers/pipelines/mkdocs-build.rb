require 'json'
require 'template-runner'

class MkdocsBuild
    def createDeployPipeline (parameters)
        attributes = parameters

        type = attributes['type']
        project = attributes['name']
        version = attributes['version']
        branch = attributes['branch']

        attributes['project'] = "#{project}"
        attributes['group'] = "#{project}"


        attributes['CONSUL_URL'] = ENV['CONSUL_URL']

        attributes['project'] = "#{project}"
        attributes['group'] = "#{project}"

        attributes['build_pipeline_label'] = "${#{attributes['build_pipeline']}}"


        t = Template.new

        stageTemplate = getFragmentPath("stage.json")
        jobTemplate = getFragmentPath("job.json")
        taskTemplate1 = getFragmentPath("task-fetch.json")
        taskTemplate2 = getFragmentPath("task-docker-canzea.json")
        taskTemplate3 = getFragmentPath("task-sudo-register-service.json")

        root = JSON.parse(t.process getFragmentPath("pipeline-deploy.json"), attributes)

        material = JSON.parse(t.process getFragmentPath("material-pipeline.json"), attributes)
        root['pipeline']['materials'].push (material)

        material = JSON.parse(t.process getFragmentPath("material.json"), {"url"=>"https://#{ENV['ECOSYSTEM']}.canzea.cc/gogs/root/ecosystems.git","name"=>"es-catalog","branch"=>"master"})
        root['pipeline']['materials'].push (material)

        stage = JSON.parse(t.process stageTemplate, {"name" => "Deploy"})

        job = JSON.parse(t.process jobTemplate, attributes)

        task = JSON.parse(t.process taskTemplate1, {"project" => project, "version" => version})
        job['tasks'].push (task)

        params = { "port" => attributes['port'], "env" => attributes['env'], "name" => attributes['name'], "branch" => attributes['branch'] }
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

        item = {
            "pipeline_pipeline" => {
                attributes['rid'] => root
            }
        }
        return JSON.pretty_generate( item )

    end

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

        task = JSON.parse(t.process taskTemplate2, {"project" => attributes['project'], "arguments" => ["#{project}-task", "mkdocs", "build"] })
        job['tasks'].push (task)

        root['pipeline']['stages'].push (stage)


        stage = JSON.parse(t.process stageTemplate, {"name" => "Registry"})

        job = JSON.parse(t.process jobTemplate, attributes)
        stage['jobs'].push(job)

        params = { }
        params = params.to_json.to_json
        params = params.slice(1,params.length - 2)

        task = JSON.parse(t.process taskTemplateCanzea, {"workingdir" => attributes['project'], "project" => attributes['project'], "solution" => "gocd", "action" => "prep-build-mkdocs", "parameters" => params })
        job['tasks'].push (task)

        taskTemplate = getFragmentPath("task-mvn-package.json")
        task = JSON.parse(t.process taskTemplate, {"project" => attributes['project']})
        job['tasks'].push (task)

        taskTemplate = getFragmentPath("task-mvn-deploy.json")
        task = JSON.parse(t.process taskTemplate, {"project" => attributes['project']})
        job['tasks'].push (task)

        artifactTemplate = getFragmentPath("artifact-assembly.json")
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

        dockerFile = File.read("#{ENV['CATALOG_LOCATION']}/helpers/config_writers/pipelines/commands/mkdocs.script")

        return [
            { "file" => "components/#{project}/Dockerfile", "content" => dockerFile }
        ]
    end
end
