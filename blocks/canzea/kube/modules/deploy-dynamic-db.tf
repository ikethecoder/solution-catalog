resource "canzea_resource" "cicd-pipeline-canzea-dynamic-db-app" {
    path = "/cicd/config"

    attributes = {
        filename = "ecosystems/${var.es_id}/workspaces/${var.workspace}/pipeline-canzea-dynamic-db.gocd.yaml"
        definition = <<-EOT

            format_version: 3
            pipelines:
                ${var.tenant_id}-canzea-dynamic-db-${var.workspace}:
                    group: ${var.tenant_id}
                    environment_variables:
                        PROJECT: dynamic-db
                        TENANT: ${var.tenant_id}
                    materials:
                        charts:
                            git: https://gitlab.com/ikethecoder/helm-charts.git
                            branch: develop
                            auto_update: false
                        myupstream:
                            pipeline: ${var.tenant_id}-dynamic-db
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

                            vault read -field kube_raw_config secret/tenants/${var.tenant_id}/${var.workspace}/cluster > kube_config
                            vault read -field data -format yaml secret/tenants/${var.tenant_id}/${var.workspace}/services/dynamic-db > env.yaml

                    - deploy:
                        clean_workspace: true
                        elastic_profile_id: helm321
                        tasks:
                        - fetch:
                            pipeline: ${var.tenant_id}-canzea-dynamic-db-${var.workspace}
                            stage: vault
                            job: vault
                            source: artifacts
                            destination: .

                        - script: |

                            mkdir -p ~/.kube

                            cat artifacts/kube_config | base64 -d > ~/.kube/config

                            PARAMS_FROM_VAULT=`cat artifacts/env.yaml | fold -w 200 | awk '{ printf "%4s%s\n","",$0 }'`

                            echo "
                            replicaCount: 1

                            dynamicdb:
                            $PARAMS_FROM_VAULT

                            nodeSelector:
                                doks.digitalocean.com/node-pool: ${var.es_id}-${var.workspace}-pool

                            image:
                                repository: registry.ops.${var.domain_name}/${var.tenant_id}/dynamic-db
                                tag: latest
                                pullPolicy: Always


                            ingress:
                                enabled: true
                                hosts:
                                - dynamic-db.${var.workspace}.ws.${var.domain_name}
                                
                            " > values.local.yaml

                            /bin/sh -c "set +e && helm status $PROJECT > /dev/null 2>&1"

                            helm upgrade $PROJECT --install --recreate-pods --namespace apps -f ./values.local.yaml $PROJECT/.
        EOT
  }
}
