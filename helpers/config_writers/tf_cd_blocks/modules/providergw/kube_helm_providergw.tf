// Needs a keycloak realm and client (id/secret)
// Needs a Vault token tied to a policy for access to managing api access
// Bootstrap project (init-container)

// Create two versions, one that is for staging, and one for live
// : Staging on branch "develop", when merged to master, will do a deploy to live flow
//
resource "helm_release" "providergw" {
    name       = "providergw"
    //repository = "${helm_repository.private.metadata.0.name}"
    chart      = "private/provider-gateway"
    namespace  = "cicd"

    values = [
        <<EOF

          # _WAIT_HACK ${var.module_depends_on}

          persistence:
            enabled: true

          ingress:
            hosts:
            - providergw.cloud.${var.domain_name}

          providergw:
            security:
                ssh:
                    enabled: true
                    secretName: providergw-ssh

          admin:
            auth: oauth2
            host: "${var.oidc["host"]}"
            realm: "${var.oidc["realm"]}"
            client_id: "${var.oidc["client_id"]}"
            client_secret: "${var.oidc["client_secret"]}"

          auth:
            model: vault
            uri: "${var.vault["host"]}/"
            token: "${var.vault["token"]}"
        EOF
    ]

}

output "milestone_providergw_ready" {
  value = "READY"

  depends_on = [
    "helm_release.providergw"
  ]
}