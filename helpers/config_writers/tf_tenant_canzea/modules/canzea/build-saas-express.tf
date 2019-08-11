resource "canzea_resource" "cicd-pipeline-dev-pipeline-saas-express" {
    path = "/cicd/config"

    attributes = {
        filename = "ecosystems/es1122/workspaces/build/pipeline-saas-express.gocd.yaml"
        definition = <<-EOT

                format_version: 3
                pipelines:
                    saas-express-es1122:
                        group: canzea-es1122
                        environment_variables:
                            PROJECT: saas-express
                            TENANT: es1122
                        label_template: "$${git_1[:8]}"
                        lock_behavior: none
                        materials:
                            git_1:
                                git: git@gitlab.com:ikethecoder/saas-express.git
                                branch: develop
                                destination: saas-express
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
                                source: saas-express/target
                                destination: artifacts
                            tasks:
                            - script: |
                                cd console-app
                                mvn install -Dmaven.test.skip=true

                                cd ../saas-express
                                mvn install -Dmaven.test.skip=true

                        - deploy:
                            clean_workspace: true
                            elastic_profile_id: docker
                            tasks:
                            - fetch:
                                pipeline: saas-express-es1122
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
