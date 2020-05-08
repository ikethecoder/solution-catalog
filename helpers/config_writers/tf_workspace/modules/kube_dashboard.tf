

resource "helm_release" "kubernetes-dashboard" {
    name = "kubernetes-dashboard"
    repository = "https://kubernetes-charts.storage.googleapis.com"
    chart = "kubernetes-dashboard"
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
    ]

}