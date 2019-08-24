resource "canzea_resource" "cicd-pipeline-build" {
    path = "/cicd/config"

    attributes = {
        filename = "ecosystems/${var.es_id}/workspaces/build/pipeline-${var.project}.gocd.yaml"
        definition = <<-EOT

                format_version: 3
                pipelines:
                    ${var.tenant_id}-${var.project}:
                        group: ${var.tenant_id}
                        environment_variables:
                            PROJECT: ${var.project}
                            TENANT: ${var.tenant_id}
                        label_template: "$${source[:8]}"
                        lock_behavior: none
                        materials:
                            source:
                                git: ${var.repo["url"]}
                                branch: ${var.repo["branch"]}
                                destination: ${var.project}
                        stages:
                        - build:
                            clean_workspace: true
                            elastic_profile_id: "nodejs8"
                            artifacts:
                            - build:
                                source: ${var.project}/target
                                destination: artifacts
                            tasks:
                            - script: |
                                cd ${var.project}
                                cp -r src target

                        - templating:
                            clean_workspace: true
                            elastic_profile_id: template
                            artifacts:
                            - build:
                                source: artifacts/target
                                destination: artifacts
                            tasks:
                            - fetch:
                                pipeline: cci-cci-public
                                stage: build
                                job: build
                                source: artifacts
                                destination: .
                            - script: |
                                echo '
                                {
                                    "matches": [{
                                        "search":"%APP_VERSION%", "replace_env":"GO_PIPELINE_LABEL"
                                    }]
                                }' > config.json                            
                                
                                template artifacts/target     

                        - publish:
                            clean_workspace: true
                            elastic_profile_id: docker
                            tasks:
                            - fetch:
                                pipeline: ${var.tenant_id}-${var.project}
                                stage: templating
                                job: templating
                                source: artifacts
                                destination: .
                            - script: |
                                set -e
                                echo "
                                FROM $REGISTRY/agents/nginx-templated:latest
                                COPY artifacts/target /usr/share/nginx/html
                                " > Dockerfile
                                docker build --tag $PROJECT.local .
                                docker tag $PROJECT.local $REGISTRY/$TENANT/$PROJECT:latest
                                docker tag $PROJECT.local $REGISTRY/$TENANT/$PROJECT:$GO_PIPELINE_LABEL                                
                                docker push $REGISTRY/$TENANT/$PROJECT
                                echo "Pushed with TAG $GO_PIPELINE_LABEL"

        EOT
  }
}
