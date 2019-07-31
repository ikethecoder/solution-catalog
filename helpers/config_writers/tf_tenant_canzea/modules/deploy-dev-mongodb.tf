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
/*
resource "helm_release" "mongodb" {
    name      = "mongodb"
    chart     = "stable/mongodb"
    namespace = "db"

    values = [
        <<EOF
         mongodbUsername: "${random_string.mongoSuperUser.result}"
         mongodbPassword: "${random_string.mongoSuperPassword.result}"
         mongodbDatabase: "general"
         persistence:
           enabled: true
           size: "1Gi"
        EOF
    ]

    depends_on = [
      "null_resource.helm_init"
    ]

}
*/


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
                        PROJECT: console-app-mongodb
                        TENANT: es1122
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
                                    doks.digitalocean.com/node-pool: default-pool

                                ingress:
                                    enabled: true
                                    hosts:
                                    - mongodb.${var.workspace}.ws.${var.domain_name}

                                mongodbUsername: "${random_string.mongoSuperUser.result}"
                                mongodbPassword: "${random_string.mongoSuperPassword.result}"
                                mongodbDatabase: "general"

                                persistence:
                                    enabled: true
                                    size: "1Gi"


                            " > values.local.yaml

                            helm init --client-only

                            /bin/sh -c "set +e && helm status $PROJECT > /dev/null 2>&1"

                            if [ $? -eq 1 ]
                            then
                                helm install --name $PROJECT -f ./values.local.yaml stable/mongodb
                            else
                                helm upgrade $PROJECT --recreate-pods -f ./values.local.yaml stable/mongodb
                            fi
        EOT
  }
}
