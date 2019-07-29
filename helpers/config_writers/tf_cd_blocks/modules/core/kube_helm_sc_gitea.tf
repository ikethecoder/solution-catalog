
resource "helm_release" "gitea" {
    name      = "gitea"
    //repository = "${helm_repository.private.metadata.0.name}"
    chart     = "private/gitea"
    namespace = "cicd"

    values = [
        <<EOF

        images:
            gitea: "gitea/gitea:1.7.3"

        ingress:
            enabled: true
            tls:
            - hosts:
              - source.cloud.${var.domain_name}
        service:
            http:
                externalPort: ""
                externalHost: source.cloud.${var.domain_name}
            ssh:
                serviceType: NodePort
                nodePort: 30022
                externalHost: source.cloud.${var.domain_name}

        persistence:
            enabled: true
            giteaSize: 2Gi
            postgresSize: 1Gi
            accessMode: ReadWriteOnce

        config:
            secretKey: define_your_secret
            disableInstaller: true
        EOF
    ]

    depends_on = [
        "kubernetes_secret.docker-registry-cicd"
    ]
}