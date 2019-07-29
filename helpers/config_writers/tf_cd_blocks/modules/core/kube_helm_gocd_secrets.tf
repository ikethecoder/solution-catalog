resource "tls_private_key" "gocd_private_key" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P384"
}

resource "tls_self_signed_cert" "gocd_ssh" {
  key_algorithm   = "ECDSA"
  private_key_pem = "${tls_private_key.gocd_private_key.private_key_pem}"

  subject {
    common_name  = "gocd.cloud.${var.domain_name}"
    organization = "GOCD Deploy Key"
  }

  # 1 Year
  validity_period_hours = 8760

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]

  provisioner "local-exec" {
    command = <<EOT
        ssh-keyscan 35.231.145.151 > ${path.cwd}/_gocd_known_hosts
        ssh-keyscan gitlab.com >> ${path.cwd}/_gocd_known_hosts
        ssh-keyscan -p 30022 source-ssh.${var.domain_name} >> ${path.cwd}/_gocd_known_hosts
    EOT
  }

}

data "local_file" "gocd_known_hosts" {
  filename = "${path.cwd}/_gocd_known_hosts"  

  depends_on = [
      "tls_self_signed_cert.gocd_ssh"
  ]
}

resource "kubernetes_secret" "gocd_server_ssh" {
  metadata {
    name = "gocd-server-ssh"
    namespace = "cicd"
  }

  data {
    id_rsa = "${tls_private_key.gocd_private_key.private_key_pem}"
    id_rsa.pub = "${tls_private_key.gocd_private_key.public_key_openssh}"
    known_hosts = "${data.local_file.gocd_known_hosts.content}"
    config = <<-EOT
    Host source.cloud.${var.domain_name}
      HostName source-ssh.${var.domain_name}
      Port 30022
    EOT
  }
}


resource "kubernetes_secret" "gocd_agent_ssh" {
  metadata {
    name = "gocd-agent-ssh"
    namespace = "cicd"
  }

  data {
    id_rsa = "${tls_private_key.gocd_private_key.private_key_pem}"
    id_rsa.pub = "${tls_private_key.gocd_private_key.public_key_openssh}"
    known_hosts = "${data.local_file.gocd_known_hosts.content}"
    config = <<-EOT
    Host source.cloud.${var.domain_name}
      HostName source-ssh.${var.domain_name}
      Port 30022
    EOT
  }
}


resource "kubernetes_secret" "gocd_git_credentials" {
  metadata {
    name = "gocd-git-credentials"
    namespace = "cicd"
  }

  data {
    ".git-credentials" = "https://es2222-xxxxx:KjxQX_7CiRVs6F86DmBv@gitlab.com"
  }
}



resource "kubernetes_secret" "providergw_ssh" {
  metadata {
    name = "providergw-ssh"
    namespace = "cicd"
  }

  data {
    id_rsa = "${tls_private_key.gocd_private_key.private_key_pem}"
    id_rsa.pub = "${tls_private_key.gocd_private_key.public_key_openssh}"
    known_hosts = "${data.local_file.gocd_known_hosts.content}"
    config = <<-EOT
    Host source.cloud.${var.domain_name}
      HostName source-ssh.${var.domain_name}
      Port 30022
    EOT
  }
}