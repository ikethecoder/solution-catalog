require 'json'
require 'template-runner'

class Deploy

    def createPipeline (parameters)

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

        # material = JSON.parse(t.process getFragmentPath("material-environment.json"), attributes)
        # root['pipeline']['materials'].push (material)


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

    def getFragmentPath (fileRelativePath)
        return "#{ENV['CATALOG_LOCATION']}/helpers/config_writers/pipelines/fragment/#{fileRelativePath}"
    end
end

