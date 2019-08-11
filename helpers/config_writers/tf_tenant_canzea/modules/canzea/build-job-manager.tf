resource "canzea_resource" "cicd-pipeline-dev-pipeline-job-manager" {
    path = "/cicd/config"

    attributes = {
        filename = "ecosystems/es1122/workspaces/build/pipeline-job-manager.gocd.yaml"
        definition = <<-EOT

                format_version: 3
                pipelines:
                    job-manager-es1122:
                        group: canzea-es1122
                        environment_variables:
                            PROJECT: job-manager
                            TENANT: es1122
                        label_template: "$${git_1[:8]}"
                        lock_behavior: none
                        materials:
                            git_1:
                                git: git@gitlab.com:ikethecoder/job-manager.git
                                branch: develop
                                destination: job-manager
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
                                source: job-manager/target
                                destination: artifacts
                            tasks:
                            - script: |
                                cd console-app
                                mvn install -Dmaven.test.skip=true

                                cd ../job-manager
                                mvn install -Dmaven.test.skip=true

                        - deploy:
                            clean_workspace: true
                            elastic_profile_id: docker
                            tasks:
                            - fetch:
                                pipeline: job-manager-es1122
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