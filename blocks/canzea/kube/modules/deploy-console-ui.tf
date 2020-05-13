resource "random_string" "mongoSuperUser" {
  length = 6
  special = false
  override_special = "/@\" "
}

resource "random_string" "mongoSuperPassword" {
  length = 16
  special = false
  override_special = "/@\" "
}


resource "canzea_resource" "cicd-pipeline-pipeline-canzea-console-ui" {
    path = "/cicd/config"

    attributes = {
        filename = "ecosystems/${var.es_id}/workspaces/${var.workspace}/pipeline-canzea-console-ui.gocd.yaml"
        definition = <<-EOT

            format_version: 3
            pipelines:
                ${var.tenant_id}-canzea-console-ui-${var.workspace}:
                    group: ${var.tenant_id}
                    environment_variables:
                        PROJECT: console-ui
                        TENANT: ${var.tenant_id}
                    materials:
                        charts:
                            git: https://gitlab.com/ikethecoder/helm-charts.git
                            branch: develop
                            auto_update: false
                        myupstream:
                            pipeline: ${var.tenant_id}-console-ui
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
                        - build:
                            source: s3cfg
                            destination: artifacts
                        tasks:
                        - script: |
                            vault status

                            export VAULT_TOKEN=$(vault write -field token auth/approle/login \
                                role_id=$VAULT_ROLE_ID \
                                secret_id=$VAULT_SECRET_ID)

                            vault read -field kube_raw_config secret/tenants/${var.tenant_id}/${var.workspace}/cluster > kube_config
                            vault read -field data -format yaml secret/tenants/${var.tenant_id}/${var.workspace}/services/console-ui > env.yaml
                            vault read -field data -format json secret/tenants/${var.tenant_id}/${var.workspace}/providers/do_s3 > s3cfg

                    - deploy:
                        clean_workspace: true
                        elastic_profile_id: helm321
                        tasks:
                        - fetch:
                            pipeline: ${var.tenant_id}-canzea-console-ui-${var.workspace}
                            stage: vault
                            job: vault
                            source: artifacts
                            destination: .

                        - script: |

                            mkdir -p ~/.kube

                            cat artifacts/kube_config | base64 -d > ~/.kube/config

                            PARAMS_FROM_VAULT=`cat artifacts/env.yaml | fold -w 200 | awk '{ printf "%4s%s\n","",$0 }'`

                            echo "
                            replicaCount: 2

                            consoleui:
                            $PARAMS_FROM_VAULT
                                clientVersion: "b$GO_DEPENDENCY_LABEL_MYUPSTREAM.$GO_PIPELINE_LABEL"

                            nodeSelector:
                                doks.digitalocean.com/node-pool: ${var.es_id}-${var.workspace}-pool

                            image:
                                repository: registry.ops.${var.domain_name}/${var.tenant_id}/console-ui
                                tag: $GO_DEPENDENCY_LABEL_MYUPSTREAM
                                pullPolicy: Always

                            ingress:
                                enabled: true
                                hosts:
                                - console.prod.ws.${var.domain_name}
                                - canzea.cloud
                                tls:
                                - secretName: canzea-cloud-ssl
                                  hosts:
                                  - canzea.cloud
                                
                            " > values.local.yaml

                            /bin/sh -c "set +e && helm status $PROJECT > /dev/null 2>&1"

                            helm upgrade $PROJECT --install --recreate-pods --namespace apps -f ./values.local.yaml $PROJECT/.

                    - deploy_static:
                        clean_workspace: true
                        elastic_profile_id: cloud-aws
                        tasks:
                        - fetch:
                            pipeline: ${var.tenant_id}-canzea-console-ui-${var.workspace}
                            stage: vault
                            job: vault
                            source: artifacts
                            destination: .
                        - fetch:
                            pipeline: ${var.tenant_id}-console-ui
                            stage: build
                            job: build
                            source: artifacts
                            destination: .
                        - script: |

                            ACCESS_KEY=`cat artifacts/s3cfg | jq -r ".access_key"`
                            SECRET_KEY=`cat artifacts/s3cfg | jq -r ".secret_key"`
                            BUCKET=`cat artifacts/s3cfg | jq -r ".bucket"`

                            echo "
                            [default]
                                access_key = $ACCESS_KEY
                                host_base = sfo2.digitaloceanspaces.com 
                                host_bucket = %(bucket)s.sfo2.digitaloceanspaces.com
                                secret_key = $SECRET_KEY
                                verbosity = INFO
                            " > ~/.s3cfg
                            
                            cat ~/.s3cfg

                            (cd artifacts/web && s3cmd sync --acl-public . s3://$BUCKET/$TENANT/console-ui.${var.workspace}.ws/)
        EOT
  }
}
