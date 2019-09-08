

# Resource Example

```yaml
resources:
  - tf_project:
      cci-public:
        tenant_id: "cci"
        repo_url: "git@gitlab.com:ikethecoder/cci-public.git"
        repo_branch: "develop"
        deploy_workspace: "${environment.id}"
        dns_prefix: "www"

resources:
  - tf_project:
      data-mining:
        tenant_id: "cci"
        repo_url: "git@gitlab.com:ikethecoder/data-mining.git"
        repo_branch: "master"
        deploy_workspace: "${environment.id}"
        dns_prefix: "mining"

```

# Remaining work

* Helm chart - add to https://gitlab.com/ikethecoder/helm-charts.git
* Adding the pipelines to the environments
* Vault settings for HELM
* Hooks

# TLS

```yaml
ingress:
    enabled: true
    hosts:
    - ${var.dns_prefix}.${var.deploy_workspace}.ws.${var.domain_name}
    - copeconsulting.ca

    tls:
        - secretName: cci-ssl
          hosts:
            - copeconsulting.ca

```