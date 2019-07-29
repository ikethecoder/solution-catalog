# https://www.npmjs.com/package/simple-git


# add environments and pipelines to config_repo ecosystem_operations


resource "canzea_resource" "cicd-environments-es2222-dev-file" {
  path = "/cicd/config"

  attributes = {
      filename = "ecosystems/es1122/workspaces/dev/environment.gocd.yaml"
      role_id = "${canzea_static_resource.cicd-encrypted-role-id.api_data["encrypted_value"]}"
      definition = <<-EOT

            format_version: 3
            environments:
                es2222-dev-x:
                    environment_variables:
                        VAULT_ADDR: "https://vault.ops.${var.domain_name}"
                        REGISTRY: "registry.ops.${var.domain_name}"
                    secure_variables:
                        VAULT_ROLE_ID: "${canzea_static_resource.cicd-encrypted-role-id.api_data["encrypted_value"]}"
                        VAULT_SECRET_ID: "${canzea_static_resource.cicd-encrypted-secret-id.api_data["encrypted_value"]}"
                    pipelines:
                    - es1122-canzea-public-dev
                    - es1122-dynamic-db-dev
                    - es1122-job-manager-dev
                    - es1122-saas-express-dev
                    - es1122-console-app-mongodb-dev
                    - es1122-console-app-rabbitmq-dev
                    - es1122-console-ui-dev
        EOT
  }
}



resource "canzea_resource" "cicd-pipeline-es2222-dev-pipeline-canzea-public" {
    path = "/cicd/config"

    attributes = {
        filename = "ecosystems/es1122/workspaces/dev/pipeline-canzea-public.gocd.yaml"
        definition = <<-EOT

            format_version: 3
            pipelines:
                es1122-canzea-public-dev:
                    group: canzea-es1122
                    environment_variables:
                        PROJECT: canzea-public
                        TENANT: es1122
                    materials:
                        charts:
                            git: https://gitlab.com/ikethecoder/helm-charts.git
                            branch: develop
                            auto_update: false
                        myupstream:
                            pipeline: canzea-public-es1122
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
                            pipeline: es1122-canzea-public-dev
                            stage: vault
                            job: vault
                            source: artifacts
                            destination: .

                        - script: |

                            mkdir -p ~/.kube

                            cat artifacts/kube_config | base64 -d > ~/.kube/config

                            echo "
                                replicaCount: 3

                                app:
                                    version: \"$GO_DEPENDENCY_LABEL_MYUPSTREAM\"

                                nodeSelector:
                                    doks.digitalocean.com/node-pool: default-pool

                                image:
                                    repository: registry.ops.184768.xyz/es1122/canzea-public
                                    tag: latest
                                    pullPolicy: Always

                                ingress:
                                    enabled: true
                                    hosts:
                                    - public-dev.es2222.184768.xyz
                                
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
                            pipeline: es1122-dynamic-db-dev
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

                                image:
                                    repository: registry.ops.184768.xyz/es1122/dynamic-db
                                    tag: latest
                                    pullPolicy: Always

                                ingress:
                                    enabled: true
                                    hosts:
                                    - dynamic-db-dev.es2222.184768.xyz
                                
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


resource "canzea_resource" "cicd-pipeline-es2222-dev-pipeline-saas-express-app" {
    path = "/cicd/config"

    attributes = {
        filename = "ecosystems/es1122/workspaces/dev/pipeline-saas-express.gocd.yaml"
        definition = <<-EOT

            format_version: 3
            pipelines:
                es1122-saas-express-dev:
                    group: canzea-es1122
                    environment_variables:
                        PROJECT: saas-express
                        TENANT: es1122
                    materials:
                        charts:
                            git: https://gitlab.com/ikethecoder/helm-charts.git
                            branch: develop
                            auto_update: false
                        myupstream:
                            pipeline: saas-express-es1122
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
                            pipeline: es1122-saas-express-dev
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

                                image:
                                    repository: registry.ops.184768.xyz/es1122/saas-express
                                    tag: latest
                                    pullPolicy: Always

                                ingress:
                                    enabled: true
                                    hosts:
                                    - saas-express-dev.es2222.184768.xyz
                                
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

resource "canzea_resource" "cicd-pipeline-es2222-dev-pipeline-job-manager-app" {
    path = "/cicd/config"

    attributes = {
        filename = "ecosystems/es1122/workspaces/dev/pipeline-job-manager.gocd.yaml"
        definition = <<-EOT

            format_version: 3
            pipelines:
                es1122-job-manager-dev:
                    group: canzea-es1122
                    environment_variables:
                        PROJECT: job-manager
                        TENANT: es1122
                    materials:
                        charts:
                            git: https://gitlab.com/ikethecoder/helm-charts.git
                            branch: develop
                            auto_update: false
                        myupstream:
                            pipeline: job-manager-es1122
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
                            pipeline: es1122-job-manager-dev
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

                                image:
                                    repository: registry.ops.184768.xyz/es1122/job-manager
                                    tag: latest
                                    pullPolicy: Always


                                persistence:
                                    enabled: true
                                    size: "1Gi"

                                ingress:
                                    enabled: true
                                    hosts:
                                    - job-manager-dev.es2222.184768.xyz
                                
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
                                    - console-app-mongodb-dev.es2222.184768.xyz

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



resource "canzea_resource" "cicd-pipeline-es2222-dev-pipeline-console-app-rabbitmq" {
    path = "/cicd/config"

    attributes = {
        filename = "ecosystems/es1122/workspaces/dev/pipeline-console-app-rabbitmq.gocd.yaml"
        definition = <<-EOT

            format_version: 3
            pipelines:
                es1122-console-app-rabbitmq-dev:
                    group: canzea-es1122
                    environment_variables:
                        PROJECT: console-app-rabbitmq
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
                            pipeline: es1122-console-app-rabbitmq-dev
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
                                    - console-app-rabbitmq-dev.es2222.184768.xyz

                                rabbitmq:
                                    username: "${random_string.rabbitmqSuperUser.result}"
                                    password: "${random_string.rabbitmqSuperPassword.result}"

                                persistence:
                                    enabled: true
                                    size: "1Gi"

                            " > values.local.yaml

                            helm init --client-only

                            /bin/sh -c "set +e && helm status $PROJECT > /dev/null 2>&1"

                            if [ $? -eq 1 ]
                            then
                                helm install --name $PROJECT -f ./values.local.yaml stable/rabbitmq
                            else
                                helm upgrade $PROJECT --recreate-pods -f ./values.local.yaml stable/rabbitmq
                            fi
        EOT
  }
}


resource "random_string" "rabbitmqSuperUser" {
  length = 6
  special = false
  override_special = "/@\" "
}

resource "random_string" "rabbitmqSuperPassword" {
  length = 16
  special = false
  override_special = "/@\" "
}

