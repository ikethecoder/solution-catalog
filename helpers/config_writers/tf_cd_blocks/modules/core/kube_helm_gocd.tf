resource "random_string" "gocd-admin-password" {
  length = 16
  special = false
  override_special = "/@\" "
}

resource "kubernetes_secret" "gocd-passwords" {
  metadata {
    name = "gocd-passwords"
    namespace = "cicd"
  }

  data {
    ".passwords" = "admin:${bcrypt(random_string.gocd-admin-password.result)}"
  }
}

// Get the plugins added
// Use providergw to do the configuration
// Source control credentials need to be added in (confd?)
//
resource "helm_release" "gocd" {
    name       = "gocd"
    repository = "${data.helm_repository.private.metadata.0.name}"
    chart      = "private/gocd"
    version    = "1.6.9"

    recreate_pods = true

    namespace  = "cicd"

    values = [
        <<EOF
        kubernetes:
          ca_cert: ${base64encode(var.kube_cluster_ca_certificate)}

        registry:
          host: registry.ops.${var.domain_name}
          
        agent:
          persistence:
            enabled: false
          security:
            ssh:
              enabled: true
              secretName: ${kubernetes_secret.gocd_agent_ssh.metadata.0.name}
            gitcred:
              enabled: true
              secretName: ${kubernetes_secret.gocd_git_credentials.metadata.0.name}

        server:
          shouldPreconfigure: true

          plugins:
            websocket_user: "admin"
            websocket_password: "${random_string.gocd-admin-password.result}"

          security:
            ssh:
              enabled: true
              secretName: ${kubernetes_secret.gocd_server_ssh.metadata.0.name}
            gitcred:
              enabled: true
              secretName: ${kubernetes_secret.gocd_git_credentials.metadata.0.name}

          ingress:
            enabled: true
            hosts:
            - gocd.cloud.${var.domain_name}

          env:
            # server.env.goServerSystemProperties is a list of Java system properties, which needs to be provided to the GoCD Server, typically prefixed with -D unless otherwise stated.
            # Example: "-Xmx4096mb -Dfoo=bar"
            goServerSystemProperties:
            #  server.env.extraEnvVars is the list of environment variables passed to GoCD Server
            extraEnvVars:
              - name: GOCD_PLUGIN_INSTALL_kubernetes-elastic-agents
                value: https://github.com/gocd/kubernetes-elastic-agents/releases/download/2.1.0-123/kubernetes-elastic-agent-2.1.0-123.jar
              - name: GOCD_PLUGIN_INSTALL_docker-registry-artifact-plugin
                value: https://github.com/gocd/docker-registry-artifact-plugin/releases/download/1.0.0-25/docker-registry-artifact-plugin-1.0.0-25.jar
              - name: GOCD_PLUGIN_INSTALL_gocd-websocket-notifier
                value: https://github.com/matt-richardson/gocd-websocket-notifier/releases/download/0.4.2%2Bbuild.60/gocd-websocket-notifier.jar
              - name: GOCD_PLUGIN_INSTALL_yaml-config-plugin
                value: https://github.com/tomzo/gocd-yaml-config-plugin/releases/download/0.8.6/yaml-config-plugin-0.8.6.jar
              - name: GOCD_PLUGIN_INSTALL_script-executor
                value: https://helm.ops.${var.domain_name}/charts/misc/script-executor-0.3.0.jar
              - name: GOCD_PLUGIN_INSTALL_generic-auth
                value: https://helm.ops.${var.domain_name}/charts/misc/generic-oauth-authorization-plugin-1.0.0-2.jar


          persistence:
            enabled: true
            size: 30Gi
            extraVolumeMounts:
              - name: gocd-passwords
                mountPath: /etc/go/
                readOnly: true
            extraVolumes:
              - name: gocd-passwords
                secret:
                  secretName: ${kubernetes_secret.gocd-passwords.metadata.0.name}
                  defaultMode: 0744
        EOF
    ]

    depends_on = [
      "null_resource.helm_init"
    ]
}
