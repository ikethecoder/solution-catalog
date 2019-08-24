
resource "canzea_resource" "gocd_elastic_profile_hugo" {
  path = "/cicd/elastic_profile"

  attributes = {
      name = "hugo"
      image = "registry.ops.${var.domain_name}/agents/static-hugo:latest"
  }
}

resource "canzea_resource" "gocd_elastic_profile_template" {
  path = "/cicd/elastic_profile"

  attributes = {
      name = "template"
      image = "registry.ops.${var.domain_name}/agents/static-template:latest"
  }
}

resource "canzea_resource" "gocd_elastic_profile_java8" {
  path = "/cicd/elastic_profile"

  attributes = {
      name = "java8"
      image = "registry.ops.${var.domain_name}/agents/stack-java8:latest"
  }
}

resource "canzea_resource" "gocd_elastic_profile_nodejs8" {
  path = "/cicd/elastic_profile"

  attributes = {
      name = "nodejs8"
      image = "registry.ops.${var.domain_name}/agents/stack-nodejs8:latest"
  }
}


resource "canzea_resource" "gocd_elastic_profile_python37" {
  path = "/cicd/elastic_profile"

  attributes = {
      name = "python37"
      image = "registry.ops.${var.domain_name}/agents/stack-python37:latest"
  }
}

resource "canzea_resource" "gocd_elastic_profile_golang111" {
  path = "/cicd/elastic_profile"

  attributes = {
      name = "golang111"
      image = "registry.ops.${var.domain_name}/agents/stack-golang111:latest"
  }
}

resource "canzea_resource" "gocd_elastic_profile_ruby25" {
  path = "/cicd/elastic_profile"

  attributes = {
      name = "ruby25"
      image = "registry.ops.${var.domain_name}/agents/stack-ruby25:latest"
  }
}

resource "canzea_resource" "gocd_elastic_profile_vault" {
  path = "/cicd/elastic_profile"

  attributes = {
      name = "vault"
      image = "registry.ops.${var.domain_name}/agents/vault:latest"
  }
}

resource "canzea_resource" "gocd_elastic_profile_terraform" {
  path = "/cicd/elastic_profile"

  attributes = {
      name = "terraform"
      image = "registry.ops.${var.domain_name}/agents/terraform:latest"
  }
}

resource "canzea_resource" "gocd_elastic_profile_docker" {
  path = "/cicd/elastic_profile"

  attributes = {
      name = "docker"
      image = "gocd/gocd-agent-docker-dind:v19.1.0"
      privileged = true
  }
}

resource "canzea_resource" "gocd_elastic_profile_helm211" {
  path = "/cicd/elastic_profile"

  attributes = {
      name = "helm211"
      image = "registry.ops.${var.domain_name}/agents/helm211:latest"
  }
}

resource "canzea_resource" "gocd_elastic_profile_cloud_aws" {
  path = "/cicd/elastic_profile"

  attributes = {
      name = "cloud-aws"
      image = "registry.ops.${var.domain_name}/agents/cloud-aws:latest"
  }
}

resource "canzea_resource" "gocd_elastic_profile_cloud_digitalocean" {
  path = "/cicd/elastic_profile"

  attributes = {
      name = "cloud-digitalocean"
      image = "registry.ops.${var.domain_name}/agents/cloud-digitalocean:latest"
  }
}
