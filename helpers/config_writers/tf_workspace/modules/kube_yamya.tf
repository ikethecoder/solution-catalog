resource "kubernetes_namespace" "apps" {
  metadata {
    name = "apps"
  }
}

# resource "kubernetes_secret" "aws" {
#   metadata {
#     name = "providers-aws"
#     namespace = "${kubernetes_namespace.apps.metadata.0.name}"
#   }

#   data {
#     aws_access_key_id = "${var.aws["aws_access_key_id"]}"
#     aws_secret_access_key = "${var.aws["aws_secret_access_key"]}"
#   }
# }

# resource "kubernetes_secret" "gcp" {
#   metadata {
#     name = "providers-gcp"
#     namespace = "${kubernetes_namespace.apps.metadata.0.name}"
#   }

#   data {
#     ".apijson" = "${var.gcp["apijson"]}"
#   }
# }

