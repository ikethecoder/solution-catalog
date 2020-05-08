
provider "vault" {
  token = "${var.vault_token}"
  address = "https://vault.ops.${var.domain_name}"
}

resource "vault_generic_secret" "cluster" {
  path = "secret/tenants/${var.tenant_id}/cluster"

  data_json = <<EOT
    {
      "domain_name": "${var.domain_name}",
      "kube_raw_config": "${base64encode(digitalocean_kubernetes_cluster.cluster.kube_config.0.raw_config)}"
    }
  EOT
}

/*

curl https://gocd.cloud.184768.xyz/go/api/admin/encrypt \
-u 'admin:wrwWzkTmgPirsapl' \
-H 'Accept: application/vnd.go.cd.v1+json' \
-H 'Content-Type: application/json' \
-X POST -d '{
  "value": "7415bf72-54da-f7a8-6ff1-08c52284060e"
}'

*/
