require 'json'
require 'template-runner'

class JavaMavenBuild
    def createDeployPipeline (parameters)
        attributes = parameters

        type = attributes['type']
        project = attributes['name']
        version = attributes['version']
        branch = attributes['branch']

        attributes['deploy_id'] = "#{project}"
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

        material = JSON.parse(t.process getFragmentPath("material.json"), {"url"=>"https://sc.#{ENV['ES_DOMAIN']}/esadmin/ecosystems.git","name"=>"es-catalog","branch"=>"master"})
        root['pipeline']['materials'].push (material)

        stage = JSON.parse(t.process stageTemplate, {"name" => "Deploy"})

        job = JSON.parse(t.process jobTemplate, attributes)

        task = JSON.parse(t.process taskTemplate1, {"project" => project, "version" => version})
        job['tasks'].push (task)

        params = { "port" => attributes['port'], "env" => attributes['env'], "project" => attributes['name'] }
        params = params.to_json.to_json
        params = params.slice(1,params.length - 2)

        task = JSON.parse(t.process taskTemplate2, {"workingdir" => "", "docker_image" => "canzea/canzea_cli", "project" => project, "version" => version, "solution" => "application", "action" => "pull-jar", "parameters" => params })
        job['tasks'].push (task)

        taskTemplateDockerCli = getFragmentPath("task-docker-cli.json")

        task = JSON.parse(t.process taskTemplateDockerCli, {"workdir" => "", "arguments" => ["build", "--build-arg", "ENV_NAME=#{attributes['environmentName']}", "--build-arg", "CONFIG=es-catalog/ecosystems/#{ENV['ECOSYSTEM']}/components/#{attributes['project']}", "-f", "es-catalog/ecosystems/#{ENV['ECOSYSTEM']}/components/#{attributes['project']}/Deploy.Dockerfile", "--tag", "#{attributes['project']}-deploy", "."] })
        job['tasks'].push (task)


        prefix = "#{attributes['instanceId']}-#{attributes['project']}"
        component = "#{attributes['project']}"
        checkPath = "#{attributes['checkPath']}"
        internalPort = "#{attributes['internal_port']}"
        artifact = "#{attributes['project']}-deploy"
        wd = "es-catalog/ecosystems/#{ENV['ECOSYSTEM']}/components"
        newTask(job,wd,["shared/prepare-env-vars.py",component,prefix,"release"].concat("#{attributes['ports']}".split(',')))
        newTask(job,wd,["shared/command.py","plus-service-discovery-service","all",component,"#{attributes['instanceIp']}", prefix, checkPath])
        newTask(job,wd,["shared/command.py","graceful-shutdown","up",prefix])
        newTask(job,wd,["shared/command.py","create-docker","up",artifact,prefix,internalPort,""])
        newTask(job,wd,["shared/command.py","register-service","up",artifact,prefix])
        newTask(job,wd,["shared/command.py","graceful-shutdown","down",prefix])

        #taskTemplateSh = getFragmentPath("task-sh.json")
        #task = JSON.parse(t.process taskTemplateSh, {"workdir" => "", "arguments" => ["-c", "/usr/bin/docker rm -f #{attributes['project']}-deploy || true"] })
        #job['tasks'].push (task)

        #task = JSON.parse(t.process taskTemplateDockerCli, {"workdir" => "es-catalog/ecosystems/#{ENV['ECOSYSTEM']}/components/#{attributes['project']}", "arguments" => ["create", "--name", "#{attributes['project']}-deploy", "-p", "#{attributes['port']}:#{attributes['internal_port']}", "-e", "GO_PIPELINE_LABEL", "#{attributes['project']}-deploy"] })
        #job['tasks'].push (task)

        #task = JSON.parse(t.process taskTemplate3, {"workdir" => "es-catalog/ecosystems/#{ENV['ECOSYSTEM']}/components/#{attributes['project']}", "project" => "#{project}", "service" => "docker.service" })
        #job['tasks'].push (task)

        stage['jobs'].push(job)

        root['pipeline']['stages'].push (stage)

        item = {
            "pipeline_pipeline" => {
                attributes['rid'] => root
            }
        }
        return JSON.pretty_generate( item )

    end

    def newTask (job,workdir,args)
        t = Template.new
        taskTemplatePython = getFragmentPath("task-python.json")
        task = JSON.parse(t.process taskTemplatePython, {"workdir" => workdir, "arguments" => args })
        job['tasks'].push (task)
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

        stageTemplate = getFragmentPath("stage-first.json")
        stageNoFetchTemplate = getFragmentPath("stage-no-fetch.json")

        jobTemplate = getFragmentPath("job.json")

        root = JSON.parse(t.process getFragmentPath("pipeline.json"), attributes)

        material = JSON.parse(t.process getFragmentPath("material-core.json"), attributes)
        root['pipeline']['materials'].push (material)

        material = JSON.parse(t.process getFragmentPath("material.json"), {"url"=>"https://sc.#{ENV['ES_DOMAIN']}/esadmin/ecosystems.git","name"=>"es-catalog","branch"=>"master"})
        root['pipeline']['materials'].push (material)

        taskTemplateCanzea = getFragmentPath("task-canzea.json")

        stage = JSON.parse(t.process stageTemplate, {"name" => "Build"})

        job = JSON.parse(t.process jobTemplate, attributes)
        stage['jobs'].push(job)

        taskTemplate1 = getFragmentPath("task-docker-cli.json")
        taskTemplate2 = getFragmentPath("task-docker.json")

#        task = JSON.parse(t.process taskTemplate2, {"project" => attributes['project'], "arguments" => ["-e", "GO_PIPELINE_LABEL", "canzea/canzea_cli", "template", "src/app/config/config.js", "src/app/config/config.js"] })
#        job['tasks'].push (task)

        task = JSON.parse(t.process taskTemplate1, {"workdir" => "es-catalog/ecosystems/#{ENV['ECOSYSTEM']}/components/#{attributes['project']}", "arguments" => ["build", "--tag", "#{project}-task", "."] })
        job['tasks'].push (task)

        task = JSON.parse(t.process taskTemplate2, {"project" => attributes['project'], "arguments" => ["#{project}-task", "mvn", "clean", "install"] })
        job['tasks'].push (task)

        root['pipeline']['stages'].push (stage)

        stage = JSON.parse(t.process stageNoFetchTemplate, {"name" => "Registry"})

        job = JSON.parse(t.process jobTemplate, attributes)
        stage['jobs'].push(job)

        taskTemplate2 = getFragmentPath("task-mvn-deploy.json")
        task = JSON.parse(t.process taskTemplate2, {"project" => attributes['project']})
        job['tasks'].push (task)

        if (attributes.has_key? "module")
            attributes['projectModule'] = "#{project}/#{attributes['module']}"
        else
            attributes['projectModule'] = "#{project}"
        end
        artifactTemplate = getFragmentPath("artifact.json")
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
        t = Template.new

        project = parameters['name']

        metadataFile = t.process("#{ENV['CATALOG_LOCATION']}/helpers/config_writers/pipelines/metadata/static.metadata.tmpl", parameters)
        dockerFile = File.read("#{ENV['CATALOG_LOCATION']}/helpers/config_writers/pipelines/commands/maven.script")
        deployDockerFile = t.process("#{ENV['CATALOG_LOCATION']}/helpers/config_writers/pipelines/commands-deploy/java.script", parameters)
        dockerService = t.process("#{ENV['CATALOG_LOCATION']}/helpers/config_writers/pipelines/commands-deploy/docker.service", parameters)

        return [
            { "file" => "components/#{project}/Dockerfile", "content" => dockerFile },
            { "file" => "components/#{project}/docker.service", "content" => dockerService },
            { "file" => "components/#{project}/Deploy.Dockerfile", "content" => deployDockerFile },
            { "file" => "components/#{project}/metadata.json", "content" => metadataFile }
        ]

    end

end

