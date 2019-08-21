

# Resource Example

```yaml
resources:
  - tf_project:
      cci-public:
        tenant_id: "cci"
        repo_url: "git@gitlab.com:ikethecoder/cci-public.git"
        repo_branch: "develop"
        deploy_workspace: "${environment.id}"
        dns_prefix: "w"



```

# Remaining work

* Helm chart - add to https://gitlab.com/ikethecoder/helm-charts.git
* Adding the pipelines to the environments
* Vault settings for HELM
* Hooks
