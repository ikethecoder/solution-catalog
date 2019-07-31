resource "kubernetes_service_account" "admin-user" {
  metadata {
    name = "admin-user"
    namespace = "kube-system"
  }
  automount_service_account_token = true

}

resource "kubernetes_cluster_role_binding" "admin-user" {
    metadata {
        name = "admin-user"
    }
    role_ref {
        api_group = "rbac.authorization.k8s.io"
        kind = "ClusterRole"
        name = "cluster-admin"
    }
    subject {
        kind = "ServiceAccount"
        name = "admin-user"
        namespace = "kube-system"
        api_group = ""
    }
}


// outputs : kubernetes_service_account.admin-user.default_secret_name

// get secret



/*
output "kube-admin-token" {
    value = "${kubernetes_secret.admin-user.id}"
}
*/
