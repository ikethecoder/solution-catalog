resource null_resource "helm_init" {
    provisioner local-exec {
        command = "echo nothing"
    }

    depends_on = [
        "kubernetes_service_account.tiller",
        "kubernetes_cluster_role_binding.tiller"
    ]
}

resource "kubernetes_role" "kubernetes-dashboard-minimal" {
  metadata {
    name = "kubernetes-dashboard-minimal"
    namespace = "kube-system"
  }

  rule {
    api_groups = [""]
    resources = ["secrets"]
    verbs = ["create"]
  }
  rule {
    api_groups = [""]
    resources = ["configmaps"]
    verbs = ["create"]
  }
  rule {
    api_groups = [""]
    resources = ["secrets"]
    resource_names = ["kubernetes-dashboard-key-holder", "kubernetes-dashboard-certs"]
    verbs = ["get", "update", "delete"]
  }
  rule {
    api_groups = [""]
    resources = ["configmaps"]
    resource_names = ["kubernetes-dashboard-settings"]
    verbs = ["get", "update"]
  }
  rule {
    api_groups = [""]
    resources = ["services"]
    resource_names = ["heapster"]
    verbs = ["proxy"]
  }
  rule {
    api_groups = [""]
    resources = ["services/proxy"]
    resource_names = ["heapster", "http:heapster:", "https:heapster:"]
    verbs = ["get"]
  }
}

resource "kubernetes_role_binding" "kubernetes-dashboard-minimal" {
    metadata {
        name = "kubernetes-dashboard-minimal"
        namespace = "kube-system"
    }
    role_ref {
        api_group = "rbac.authorization.k8s.io"
        kind = "Role"
        name = "kubernetes-dashboard-minimal"
    }
    subject {
        kind = "ServiceAccount"
        name = "kubernetes-dashboard"
        namespace = "kube-system"
        api_group = ""
    }
}


resource "helm_release" "heapster" {
    name = "heapster"
    chart = "stable/heapster"
    namespace = "kube-system"

    values = [
        <<EOF
           rbac:
              create: true
        EOF
    ]


    depends_on = [
      "null_resource.helm_init"
    ]
}

/*

http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/#!/overview


Aidans-MacBook-Pro-2:sbbs aidancope$ kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v1.10.1/src/deploy/recommended/kubernetes-dashboard.yaml
secret/kubernetes-dashboard-certs created
serviceaccount/kubernetes-dashboard created
role.rbac.authorization.k8s.io/kubernetes-dashboard-minimal created
rolebinding.rbac.authorization.k8s.io/kubernetes-dashboard-minimal created
deployment.apps/kubernetes-dashboard created
service/kubernetes-dashboard created

kubectl proxy


*/

resource "helm_release" "kubernetes-dashboard" {
    name = "kubernetes-dashboard"
    chart = "stable/kubernetes-dashboard"
    namespace = "kube-system"

    values = [
        <<EOF
#           enableInsecureLogin: false
#           rbac:
#              create: true
#              clusterAdminRole: false
#           serviceAccount:
#             create : true
#             name: ""
           extraArgs:
           - --insecure-bind-address=0.0.0.0
           - --insecure-port=9090
           - --enable-insecure-login
           enableInsecureLogin: true
           service:
             internalPort: 9090
             externalPort: 9090
           ingress:
             enabled: true
            #  tls:
            #  - hosts:
            #      - cluster.cloud.${var.domain_name}
            #    secretName: kubernetes-dashboard-key-holder
             hosts:
             - cluster.cloud.${var.domain_name}
        EOF
    ]

    depends_on = [
      "null_resource.helm_init"
    ]

}

/*

THIS FAILS BECAUSE THE DATA DOES NOT EXIST YET, AND THE .data.pub COMPLAINS.
EVEN WITH THE 'DEPENDS_ON' SET IN THE KUBERNETES_SECRET.DASHBOARD.

data "kubernetes_secret" "kubernetes-dashboard" {
  metadata {
    name = "kubernetes-dashboard-key-holder"
    namespace = "kube-system"
  }

  depends_on = [
    "helm_release.kubernetes-dashboard"
  ]
}

resource "kubernetes_secret" "dashboard" {
  metadata {
    name = "kubernetes-dashboard-tls-traefik"
    namespace = "kube-system"
  }

  data {
    tls.crt = "${data.kubernetes_secret.kubernetes-dashboard.data.pub}"
    tls.key = "${data.kubernetes_secret.kubernetes-dashboard.data.priv}"
  }
}

*/
