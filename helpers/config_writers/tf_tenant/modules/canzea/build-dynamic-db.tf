resource "canzea_resource" "cicd-pipeline-dev-pipeline-dynamic-db" {
    path = "/cicd/config"

    attributes = {
        filename = "ecosystems/${var.es_id}/workspaces/build/pipeline-dynamic-db.gocd.yaml"
        definition = <<-EOT

                format_version: 3
                pipelines:
                    ${var.tenant_id}-dynamic-db:
                        group: ${var.tenant_id}
                        environment_variables:
                            PROJECT: dynamic-db
                            TENANT: ${var.tenant_id}
                        label_template: "$${git_1[:8]}"
                        lock_behavior: none
                        materials:
                            git_1:
                                git: git@gitlab.com:ikethecoder/dynamic-db.git
                                branch: develop
                                destination: dynamic-db
                            git_2:
                                git: git@gitlab.com:ikethecoder/console-app.git
                                branch: develop
                                destination: console-app
                        stages:
                        - build:
                            clean_workspace: true
                            elastic_profile_id: "java8"
                            artifacts:
                            - build:
                                source: dynamic-db/target
                                destination: artifacts
                            tasks:
                            - script: |
                                cd console-app
                                mvn install -Dmaven.test.skip=true

                                cd ../dynamic-db
                                mvn install -Dmaven.test.skip=true

                        - deploy:
                            clean_workspace: true
                            elastic_profile_id: docker
                            tasks:
                            - fetch:
                                pipeline: ${var.tenant_id}-dynamic-db
                                stage: build
                                job: build
                                source: artifacts
                                destination: .
                            - script: |
                                set -e
                                echo "
                                FROM openjdk:8u151-jdk-alpine

                                RUN apk update && apk add openssl && \
                                    java -version

                                RUN adduser -D -u 1006 appuser

                                WORKDIR /home/appuser

                                USER appuser

                                COPY artifacts/target/*.jar application.jar

                                CMD java -jar application.jar
                                    
                                " > Dockerfile
                                
                                docker build --tag $PROJECT.local .
                                docker tag $PROJECT.local $REGISTRY/$TENANT/$PROJECT:latest
                                docker push $REGISTRY/$TENANT/$PROJECT

        EOT
  }
}
