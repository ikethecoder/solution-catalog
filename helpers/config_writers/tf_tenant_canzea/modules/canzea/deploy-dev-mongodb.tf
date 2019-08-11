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

resource "canzea_resource" "cicd-pipeline-es2222-dev-pipeline-console-app-mongodb" {
    path = "/cicd/config"

    attributes = {
        filename = "ecosystems/es1122/workspaces/dev/pipeline-console-app-mongodb.gocd.yaml"
        definition = <<-EOT

            format_version: 3
            pipelines:
                es1122-console-app-mongodb-dev:
                    group: canzea-es1122
                    environment_variables:
                        TENANT: es1122
                        PROJECT: canzea-mongodb
                        HELM_CHART: stable/mongodb
                    materials:
                        charts:
                            git: https://gitlab.com/ikethecoder/helm-charts.git
                            branch: develop
                            auto_update: false

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
                            pipeline: es1122-console-app-mongodb-dev
                            stage: vault
                            job: vault
                            source: artifacts
                            destination: .

                        - script: |

                            mkdir -p ~/.kube

                            cat artifacts/kube_config | base64 -d > ~/.kube/config

                            echo "
                                replicaCount: 1

                                nodeSelector:
                                    doks.digitalocean.com/node-pool: ${var.es_id}-${var.workspace}-pool

                                ingress:
                                    enabled: true
                                    hosts:
                                    - name: canzea-mongodb.${var.workspace}.ws.${var.domain_name}

                                mongodbUsername: "${random_string.mongoSuperUser.result}"
                                mongodbPassword: "${random_string.mongoSuperPassword.result}"
                                mongodbDatabase: "general"

                                persistence:
                                    enabled: true
                                    size: "1Gi"

                            " > values.local.yaml

                            helm init --client-only

                            helm upgrade --install $PROJECT --recreate-pods --namespace apps -f ./values.local.yaml $HELM_CHART

        EOT
  }
}