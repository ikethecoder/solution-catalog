resource "canzea_resource" "cicd-pipeline-es2222-dev-pipeline-console-ui" {
    path = "/cicd/config"

    attributes = {
        filename = "ecosystems/es1122/workspaces/dev/pipeline-console-ui.gocd.yaml"
        definition = <<-EOT

            format_version: 3
            pipelines:
                es1122-console-ui-dev:
                    group: canzea-es1122
                    environment_variables:
                        PROJECT: console-ui
                        TENANT: es1122
                    materials:
                        charts:
                            git: https://gitlab.com/ikethecoder/helm-charts.git
                            branch: develop
                            auto_update: false
                        myupstream:
                            pipeline: console-ui-es1122
                            stage: deploy

                    stages:
                    - vault:
                        clean_workspace: true
                        elastic_profile_id: vault
                        artifacts:
                        - build:
                            source: kube_config
                            destination: artifacts
                        tasks:
                        - script: |
                            vault status

                            export VAULT_TOKEN=$(vault write -field token auth/approle/login \
                                role_id=$VAULT_ROLE_ID \
                                secret_id=$VAULT_SECRET_ID)

                            vault read -field kube_raw_config secret/tenants/01/cluster > kube_config

                    - deploy:
                        clean_workspace: true
                        elastic_profile_id: helm211
                        tasks:
                        - fetch:
                            pipeline: es1122-console-ui-dev
                            stage: vault
                            job: vault
                            source: artifacts
                            destination: .

                        - script: |

                            mkdir -p ~/.kube

                            cat artifacts/kube_config | base64 -d > ~/.kube/config

                            echo "
                                replicaCount: 2

                                nodeSelector:
                                    doks.digitalocean.com/node-pool: default-pool

                                image:
                                    repository: registry.ops.184768.xyz/es1122/console-ui
                                    tag: latest
                                    pullPolicy: Always

                                ingress:
                                    enabled: true
                                    hosts:
                                    - console-ui-dev.es2222.184768.xyz
                                
                            " > values.local.yaml

                            helm init --client-only

                            /bin/sh -c "set +e && helm status $PROJECT > /dev/null 2>&1"

                            if [ $? -eq 1 ]
                            then
                                helm install --name $PROJECT -f ./values.local.yaml $PROJECT/.
                            else
                                helm upgrade $PROJECT --recreate-pods -f ./values.local.yaml $PROJECT/.
                            fi
        EOT
  }
}