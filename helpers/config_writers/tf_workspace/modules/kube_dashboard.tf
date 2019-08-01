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
            #      - cluster.cloud.${var.workspace}.ws.${var.domain_name}
            #    secretName: kubernetes-dashboard-key-holder
             hosts:
             - cluster.${var.workspace}.ws.${var.domain_name}
        EOF
    ]

    depends_on = [
      "null_resource.helm_init"
    ]

}