resource "canzea_resource" "cicd-pipeline-rpa-brain" {
    path = "/cicd/config"

    attributes = {
        filename = "ecosystems/${var.es_id}/workspaces/build/pipeline-rpa-brain.gocd.yaml"
        definition = <<-EOT

format_version: 3
pipelines:
  rpa-brain-es1122:
    group: libraries-es1122
    environment_variables:
      PROJECT: rpa-brain
      TENANT: es1122
    label_template: "${source[:8]}"
    lock_behavior: none
    materials:
      source:
        git: git@gitlab.com:ikethecoder/rpa-brain.git
        auto_update: false
        branch: develop
    stages:
    - build:
        clean_workspace: true
        elastic_profile_id: "python37"
        # artifacts:
        # - build:
        #    source: .
        #    destination: artifacts
        tasks:
        - script: |
            echo "nothing to do for build"
        
    - deploy:
        clean_workspace: true
        elastic_profile_id: docker
        tasks:
        # - fetch:
        #     pipeline: rpa-brain-es1122
        #     stage: build
        #     job: build
        #     source: artifacts
        #     destination: .
        - script: |
            echo "

              FROM rasa/rasa_core:latest

              RUN pip install -r requirements.txt

              RUN pip install spacy
              RUN pip install sklearn_crfsuite

              RUN python -m spacy download en

              COPY projects /projects
              COPY credentials.yml /tmp/credentials.yml
              COPY nlu_config.yml /tmp/nlu_config.yml

            " > Dockerfile

            docker build --tag $PROJECT.local .
            docker tag $PROJECT.local $REGISTRY/${TENANT}/${PROJECT}:latest
            docker push $REGISTRY/${TENANT}/${PROJECT}

        EOT
    }
}