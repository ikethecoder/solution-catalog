require 'json'
require 'template-runner'

class HugoBuild

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

        material = JSON.parse(t.process getFragmentPath("material.json"), {"url"=>"https://esdade.canzea.cc/gogs/root/ecosystems.git","name"=>"es-catalog","branch"=>"master"})
        root['pipeline']['materials'].push (material)

        taskTemplateCanzea = getFragmentPath("task-canzea.json")

        stage = JSON.parse(t.process stageTemplate, {"name" => "Build"})

        job = JSON.parse(t.process jobTemplate, attributes)
        stage['jobs'].push(job)

        taskTemplate1 = getFragmentPath("task-docker.json")

        task = JSON.parse(t.process taskTemplate1, {"project" => attributes['project'], "arguments" => ["canzea/canzea_cli", "npm", "config", "set", "jobs", "1"] })
        job['tasks'].push (task)

        task = JSON.parse(t.process taskTemplate1, {"project" => attributes['project'], "arguments" => ["canzea/canzea_cli", "npm", "install"] })
        job['tasks'].push (task)

        task = JSON.parse(t.process taskTemplate1, {"project" => attributes['project'], "arguments" => ["canzea/canzea_cli", "npm", "run", "build"] })
        job['tasks'].push (task)

        root['pipeline']['stages'].push (stage)


        stage = JSON.parse(t.process stageTemplate, {"name" => "Registry"})

        job = JSON.parse(t.process jobTemplate, attributes)
        stage['jobs'].push(job)

        params = { }
        params = params.to_json.to_json
        params = params.slice(1,params.length - 2)

        task = JSON.parse(t.process taskTemplateCanzea, {"workingdir" => attributes['project'], "project" => attributes['project'], "solution" => "gocd", "action" => "prep-build", "parameters" => params })
        job['tasks'].push (task)

        taskTemplate = getFragmentPath("task-mvn-package.json")
        task = JSON.parse(t.process taskTemplate, {"project" => attributes['project']})
        job['tasks'].push (task)

        taskTemplate = getFragmentPath("task-mvn-deploy.json")
        task = JSON.parse(t.process taskTemplate, {"project" => attributes['project']})
        job['tasks'].push (task)

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

