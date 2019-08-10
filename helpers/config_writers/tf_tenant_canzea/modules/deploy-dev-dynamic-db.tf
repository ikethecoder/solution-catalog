resource "canzea_resource" "cicd-pipeline-es2222-dev-pipeline-dynamic-db-app" {
    path = "/cicd/config"

    attributes = {
        filename = "ecosystems/es1122/workspaces/dev/pipeline-dynamic-db.gocd.yaml"
        definition = <<-EOT

            format_version: 3
            pipelines:
                es1122-dynamic-db-dev:
                    group: canzea-es1122
                    environment_variables:
                        PROJECT: dynamic-db
                        TENANT: es1122
                    materials:
                        charts:
                            git: https://gitlab.com/ikethecoder/helm-charts.git
                            branch: develop
                            auto_update: false
                        myupstream:
                            pipeline: dynamic-db-es1122
                            stage: deploy

                    stages:
                    - vault:
                        clean_workspace: true
                        elastic_profile_id: vault
                        artifacts:
                        - build:
                            source: kube_config
                            destination: artifacts
                        - build:
                            source: env.yaml
                            destination: artifacts
                        tasks:
                        - script: |
                            vault status

                            export VAULT_TOKEN=$(vault write -field token auth/approle/login \
                                role_id=$VAULT_ROLE_ID \
                                secret_id=$VAULT_SECRET_ID)

                            vault read -field kube_raw_config secret/tenants/01/cluster > kube_config
                            vault read -field data -format yaml secret/tenants/01/services/dynamicdb > env.yaml

                    - deploy:
                        clean_workspace: true
                        elastic_profile_id: helm211
                        tasks:
                        - fetch:
                            pipeline: es1122-dynamic-db-dev
                            stage: vault
                            job: vault
                            source: artifacts
                            destination: .

                        - script: |

                            mkdir -p ~/.kube

                            cat artifacts/kube_config | base64 -d > ~/.kube/config

                            PARAMS_FROM_VAULT=`cat artifacts/env.yaml | fold | awk '{ printf "%4s%s\n","",$0 }'`

                            echo "
                            replicaCount: 1

                            dynamicdb:
                            ${PARAMS_FROM_VAULT}

                            nodeSelector:
                                doks.digitalocean.com/node-pool: ${var.es_id}-${var.workspace}-pool

                            image:
                                repository: registry.ops.${var.domain_name}/es1122/dynamic-db
                                tag: latest
                                pullPolicy: Always


                            ingress:
                                enabled: true
                                hosts:
                                - dynamic-db.${var.workspace}.ws.${var.domain_name}
                                
                            " > values.local.yaml

                            helm init --client-only

                            /bin/sh -c "set +e && helm status $PROJECT > /dev/null 2>&1"

                            if [ $? -eq 1 ]
                            then
                                helm install --name $PROJECT -f ./values.local.yaml $PROJECT/.
                            else
                                helm upgrade $PROJECT --recreate-pods --namespace apps -f ./values.local.yaml $PROJECT/.
                            fi
        EOT
  }
}
