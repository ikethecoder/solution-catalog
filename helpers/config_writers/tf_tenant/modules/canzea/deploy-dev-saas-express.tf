resource "canzea_resource" "cicd-pipeline-dev-pipeline-saas-express-app" {
    path = "/cicd/config"

    attributes = {
        filename = "ecosystems/${var.es_id}/workspaces/dev/pipeline-saas-express.gocd.yaml"
        definition = <<-EOT

            format_version: 3
            pipelines:
                ${var.tenant_id}-saas-express-${var.workspace}:
                    group: ${var.tenant_id}
                    environment_variables:
                        PROJECT: saas-express
                        TENANT: ${var.tenant_id}
                    materials:
                        charts:
                            git: https://gitlab.com/ikethecoder/helm-charts.git
                            branch: develop
                            auto_update: false
                        myupstream:
                            pipeline: ${var.tenant_id}-saas-express
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

                            vault read -field kube_raw_config secret/tenants/${var.tenant_id}/cluster > kube_config
                            vault read -field data -format yaml secret/tenants/${var.tenant_id}/services/saas-express > env.yaml

                    - deploy:
                        clean_workspace: true
                        elastic_profile_id: helm211
                        tasks:
                        - fetch:
                            pipeline: ${var.tenant_id}-saas-express-${var.workspace}
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

                            saasexpress:
                            $PARAMS_FROM_VAULT

                            nodeSelector:
                                doks.digitalocean.com/node-pool: ${var.es_id}-${var.deploy_workspace}-pool

                            image:
                                repository: registry.ops.${var.domain_name}/${var.tenant_id}/saas-express
                                tag: latest
                                pullPolicy: Always

                            ingress:
                                enabled: true
                                hosts:
                                - saas-express.${var.deploy_workspace}.ws.${var.domain_name}
                            
                                
                            " > values.local.yaml

                            helm init --client-only

                            /bin/sh -c "set +e && helm status $PROJECT > /dev/null 2>&1"

                            if [ $? -eq 1 ]
                            then
                                helm install --name $PROJECT --namespace apps -f ./values.local.yaml $PROJECT/.
                            else
                                helm upgrade $PROJECT --recreate-pods --namespace apps -f ./values.local.yaml $PROJECT/.
                            fi
        EOT
  }
}
