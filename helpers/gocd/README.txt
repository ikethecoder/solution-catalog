
#
# Establish a new release (release (major, minor), hotfix (patch))
#
#ruby helpers/helper-run.rb branching create '{"app":"hello-world-svc-app", "type":"patch", "url":"git@build.escca.canzea.cc:root/hello-world-svc-app.git"}'
# Gets back say: hotfix-1.0.3


# Make sure the "Build" environment exists
# Make sure Build-A-1 Agent is added to Build environment

#
# Start a new release
#
ruby helpers/gocd/update-pipeline-for-build.rb '{"data":{"project":"hello-world-svc-app","branch":"hotfix-1.0.3", "version":"1.0.3","pattern":"Build"}}'

# Add the pipeline
ruby helpers/helper-run.rb gocd post-object '{"type":"pipelines", "name":"hello-world-svc-app-1.0.3-Build"}'

# Add the new pipeline to the Build environment
ruby helpers/helper-run.rb gocd get-object '{"type":"environments", "name":"Build"}'
ruby helpers/helper-run.rb gocd add-pipeline-to-environment '{"type":"environments", "name":"Build", "pipelineName": "hello-world-svc-app-1.0.3-Build"}'
ruby helpers/helper-run.rb gocd put-object '{"type":"environments","name":"Build"}'

# Unpause to start building
ruby helpers/helper-run.rb gocd unpause '{"pipeline":"hello-world-svc-app-1.0.0-Build"}'

#
# INTEGRATION
#
##### Create the Integration Environment
echo '{"name":"Integration"}' > environments-Integration.json
ruby helpers/helper-run.rb gocd post-object '{"type":"environments", "name":"Integration"}'

# Add a new pipeline for the deployment to integration
ruby helpers/helper-run.rb gocd get-object '{"type":"environments", "name":"Integration"}'
ruby helpers/helper-run.rb gocd add-pipeline-to-environment '{"type":"environments", "name":"Integration", "pipelineName": "hello-world-svc-app-1.0.3-Deploy"}'
ruby helpers/helper-run.rb gocd put-object '{"type":"environments","name":"Integration"}'


#
# Deploy to Integration environment
#
ruby helpers/helper-run.rb gocd get-object '{"type":"pipelines", "name":"hello-world-svc-app-1.0.1-Deploy"}'
ruby helpers/helper-run.rb gocd update-pipeline-for-deploy '{"data":{"project":"hello-world-svc-app","branch":"hotfix-1.0.3", "version":"1.0.1","pattern":"Deploy"}}'
ruby helpers/helper-run.rb gocd put-object '{"type":"pipelines", "name":"hello-world-svc-app-1.0.1-Deploy"}'


#
# UPDATE PIPELINE
#

ruby helpers/helper-run.rb gocd get-object '{"type":"pipelines", "name":"hello-world-svc-app-1.0.3-Build"}'
ruby helpers/helper-run.rb gocd update-pipeline-for-build '{"data":{"project":"hello-world-svc-app","branch":"hotfix-1.0.3", "version":"1.0.3","pattern":"Build"}}'
ruby helpers/helper-run.rb gocd put-object '{"type":"pipelines", "name":"hello-world-svc-app-1.0.3-Build"}'





ruby helpers/helper-run.rb gocd get-object-v '{"ecosystem":"ES6FB8-0001","sourceRepo":"https://gitlab.com/ikethecoder/hello-world-svc-app.git","instanceId":"build-a-01","credentials":"01","port":"8001","name":"hello-world-svc-app","checkbox":"on","versionStrategy":"","id":"e99a6585-6891-4c5d-b275-b7445eb28aa3","branch":"master","env-integration-C":"on","qualifier":"deploy_environment","url":"https://gitlab.com/ikethecoder/hello-world-svc-app.git","targetName":"hello-world-svc-app","version":"0.1.0-SNAPSHOT","localUrl":"http://198.199.88.107:90/root/hello-world-svc-app.git","localBranch":"master","login":"root","password":"admin1admin1","build_pipeline":{"pattern":"Build","type":"pipelines","name":"hello-world-svc-app-master-Build"},"build_environment":{"type":"environments","name":"Build","pipelineName":"hello-world-svc-app-master-Build"},"deploy_pipeline":{"pattern":"Deploy","type":"pipelines","name":"hello-world-svc-app-master-Deploy"},"deploy_environment":{"version":"v4","type":"environments","name":"Integration","pipelineName":"hello-world-svc-app-master-Deploy"},"artifact":{"type":"java-maven","groupId":"org.springframework","artifactId":"gs-actuator-service","version":"0.1.0-SNAPSHOT"}}'

ruby helpers/helper-run.rb gocd list-objects '{"ecosystem":"ES6FB8-0001","sourceRepo":"https://gitlab.com/ikethecoder/hello-world-svc-app.git","instanceId":"build-a-01","credentials":"01","port":"8001","name":"hello-world-svc-app","checkbox":"on","versionStrategy":"","id":"e99a6585-6891-4c5d-b275-b7445eb28aa3","branch":"master","env-integration-C":"on","qualifier":"deploy_environment","url":"https://gitlab.com/ikethecoder/hello-world-svc-app.git","targetName":"hello-world-svc-app","version":"0.1.0-SNAPSHOT","localUrl":"http://198.199.88.107:90/root/hello-world-svc-app.git","localBranch":"master","login":"root","password":"admin1admin1","build_pipeline":{"pattern":"Build","type":"pipelines","name":"hello-world-svc-app-master-Build"},"build_environment":{"type":"environments","name":"Build","pipelineName":"hello-world-svc-app-master-Build"},"deploy_pipeline":{"pattern":"Deploy","type":"pipelines","name":"hello-world-svc-app-master-Deploy"},"deploy_environment":{"version":"4","type":"agents","name":"Integration","pipelineName":"hello-world-svc-app-master-Deploy"},"artifact":{"type":"java-maven","groupId":"org.springframework","artifactId":"gs-actuator-service","version":"0.1.0-SNAPSHOT"}}'
