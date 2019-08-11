resource "canzea_resource" "cicd-environments-dev-rpa" {
  path = "/cicd/config"

  attributes = {
      filename = "ecosystems/es1122/workspaces/dev/environment-rpa.gocd.yaml"
      role_id = "${canzea_static_resource.cicd-encrypted-role-id.api_data["encrypted_value"]}"
      definition = <<-EOT

            format_version: 3
            environments:
                dev-rpa:
                    environment_variables:
                        VAULT_ADDR: "https://vault.ops.${var.domain_name}"
                        REGISTRY: "registry.ops.${var.domain_name}"
                    secure_variables:
                        VAULT_ROLE_ID: "${canzea_static_resource.cicd-encrypted-role-id.api_data["encrypted_value"]}"
                        VAULT_SECRET_ID: "${canzea_static_resource.cicd-encrypted-secret-id.api_data["encrypted_value"]}"
                    pipelines:
                    - es1122-rpa-ui-dev
                    - es1122-rpa-channel-dev
                    - es1122-rpa-brain-dev
                    - es1122-rpa-listen-dev
                    - es1122-rpa-speak-dev
        EOT
  }
}

resource "canzea_resource" "cicd-pipeline-dev-pipeline-rpa-speak" {
    path = "/cicd/config"

    attributes = {
        filename = "ecosystems/es1122/workspaces/dev/pipeline-rpa-speak.gocd.yaml"
        definition = <<-EOT

            format_version: 3
            pipelines:
                es1122-rpa-speak-dev:
                    group: canzea-es1122
                    environment_variables:
                        PROJECT: rpa-speak
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
                            pipeline: es1122-rpa-speak-dev
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

                                image:
                                    repository: registry.ops.${var.domain_name}/es1122/rpa-speak
                                    tag: latest
                                    pullPolicy: Always

                                ingress:
                                    enabled: true
                                    hosts:
                                    - rpa-speak.${var.workspace}.ws.${var.domain_name}

                            " > values.local.yaml

                            helm init --client-only

                            helm upgrade --install $PROJECT --namespace apps -f ./values.local.yaml $PROJECT/.
        EOT
  }
}


resource "canzea_resource" "cicd-pipeline-dev-pipeline-rpa-ui" {
    path = "/cicd/config"

    attributes = {
        filename = "ecosystems/es1122/workspaces/dev/pipeline-rpa-ui.gocd.yaml"
        definition = <<-EOT

            format_version: 3
            pipelines:
                es1122-rpa-ui-dev:
                    group: canzea-es1122
                    environment_variables:
                        PROJECT: rpa-ui
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
                            pipeline: es1122-rpa-ui-dev
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

                                image:
                                    repository: registry.ops.${var.domain_name}/es1122/rpa-ui
                                    tag: latest
                                    pullPolicy: Always

                                ingress:
                                    enabled: true
                                    hosts:
                                    - rpa-ui.${var.workspace}.ws.${var.domain_name}

                            " > values.local.yaml

                            helm init --client-only

                            helm upgrade --install $PROJECT --namespace apps -f ./values.local.yaml $PROJECT/.
        EOT
  }
}


resource "canzea_resource" "cicd-pipeline-dev-pipeline-rpa-listen" {
    path = "/cicd/config"

    attributes = {
        filename = "ecosystems/es1122/workspaces/dev/pipeline-rpa-listen.gocd.yaml"
        definition = <<-EOT

            format_version: 3
            pipelines:
                es1122-rpa-listen-dev:
                    group: canzea-es1122
                    environment_variables:
                        PROJECT: rpa-listen
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
                            pipeline: es1122-rpa-listen-dev
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

                                image:
                                    repository: registry.ops.${var.domain_name}/es1122/rpa-listen
                                    tag: latest
                                    pullPolicy: Always

                                ingress:
                                    enabled: true
                                    hosts:
                                    - rpa-listen.${var.workspace}.ws.${var.domain_name}

                            " > values.local.yaml

                            helm init --client-only

                            helm upgrade --install $PROJECT --namespace apps -f ./values.local.yaml $PROJECT/.
        EOT
  }
}


resource "canzea_resource" "cicd-pipeline-dev-pipeline-rpa-channel" {
    path = "/cicd/config"

    attributes = {
        filename = "ecosystems/es1122/workspaces/dev/pipeline-rpa-channel.gocd.yaml"
        definition = <<-EOT

            format_version: 3
            pipelines:
                es1122-rpa-channel-dev:
                    group: canzea-es1122
                    environment_variables:
                        PROJECT: rpa-channel
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
                            pipeline: es1122-rpa-channel-dev
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

                                image:
                                    repository: registry.ops.${var.domain_name}/es1122/rpa-channel
                                    tag: latest
                                    pullPolicy: Always

                                ingress:
                                    enabled: true
                                    hosts:
                                    - rpa-channel.${var.workspace}.ws.${var.domain_name}



                            " > values.local.yaml

                            helm init --client-only

                            helm upgrade --install $PROJECT --namespace apps -f ./values.local.yaml $PROJECT/.
        EOT
  }
}


resource "canzea_resource" "cicd-pipeline-dev-pipeline-rpa-brain" {
    path = "/cicd/config"

    attributes = {
        filename = "ecosystems/es1122/workspaces/dev/pipeline-rpa-brain.gocd.yaml"
        definition = <<-EOT

            format_version: 3
            pipelines:
                es1122-rpa-brain-dev:
                    group: canzea-es1122
                    environment_variables:
                        PROJECT: rpa-brain
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
                            pipeline: es1122-rpa-brain-dev
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

                                image:
                                    repository: registry.ops.${var.domain_name}/es1122/rpa-brain
                                    tag: latest
                                    pullPolicy: Always

                                ingress:
                                    enabled: true
                                    hosts:
                                    - rpa-brain.${var.workspace}.ws.${var.domain_name}

                            " > values.local.yaml

                            helm init --client-only

                            helm upgrade --install $PROJECT --namespace apps -f ./values.local.yaml $PROJECT/.
        EOT
  }
}
