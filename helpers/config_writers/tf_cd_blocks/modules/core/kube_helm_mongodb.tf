
resource "random_string" "mongoSuperUser" {
  length = 8
  special = false
  override_special = "/@\" "
}
resource "random_string" "mongoSuperPassword" {
  length = 16
  special = false
  override_special = "/@\" "
}
resource "helm_release" "mongodb" {
    name   = "mongodb"
    chart  = "stable/mongodb"
    namespace = "${kubernetes_namespace.cicd.metadata.0.name}"

    values = [
        <<EOF
        replicaCount: 1

        mongodbUsername: "${random_string.mongoSuperUser.result}"
        mongodbPassword: "${random_string.mongoSuperPassword.result}"
        mongodbDatabase: "general"

        persistence:
            enabled: true
            size: "10Gi"

        EOF
    ]

    depends_on = [
      "null_resource.helm_init"
    ]
}

