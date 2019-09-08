

# Resource Example

```yaml
resources:
  - tf_cicd_environment:
      build:
        tenant_id: cci
        workspace: cd
        pipelines:
        - cci-public

  - tf_cicd_environment:
      intg:
        tenant_id: cci
        workspace: intg
        pipelines:
        - cci-public-intg

  - tf_cicd_environment:
      prod:
        tenant_id: cci
        workspace: prod
        pipelines:
        - cci-public-prod

  - tf_project.2:
      cci-public:
        stack: java8
        tenant_id: cci
        repo_url: "git@gitlab.com:ikethecoder/cci-public.git"
        repo_branch: "develop"
        deploy_workspace: "${workspace.id}"
        dns_prefix: "www"

  - tf_project.2:
      cci-public-intg:
        stack: helm
        tenant_id: cci
        repo_url: "git@gitlab.com:ikethecoder/cci-public.git"
        repo_branch: "develop"
        deploy_workspace: "${workspace.id}"
        dns_prefix: "www"

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