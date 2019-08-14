resource "canzea_resource" "cicd-pipeline-dev-pipeline-saas-express" {
    path = "/cicd/config"

    attributes = {
        filename = "ecosystems/${var.es_id}/workspaces/build/pipeline-saas-express.gocd.yaml"
        definition = <<-EOT

                format_version: 3
                pipelines:
                    ${var.tenant_id}-saas-express:
                        group: ${var.tenant_id}
                        environment_variables:
                            PROJECT: saas-express
                            TENANT: ${var.tenant_id}
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
                                pipeline: ${var.tenant_id}-saas-express
                                stage: build
                                job: build
                                source: artifacts
                                destination: .
                            - script: |
                                set -e
                                echo "
                                FROM ruby:2.4.4-alpine

                                RUN apk update && apk add openssl openjdk8 && \
                                    java -version

                                ENV TERRAFORM_LATEST_VERSION="v0.11.8"
                                RUN apk add curl && \
                                    curl -L -O https://releases.hashicorp.com/terraform/0.11.8/terraform_0.11.8_linux_amd64.zip && \
                                    unzip terraform_0.11.8_linux_amd64.zip && \
                                    mv terraform /usr/local/bin/terraform && \
                                    rm -rf terraform_0.11.8_linux_amd64.zip

                                RUN apk add git make ruby-dev build-base

                                ENV CANZEA_LATEST_VERSION="v0.1.180"
                                RUN gem install canzea -v 0.1.180

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
