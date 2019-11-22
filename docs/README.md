
# Maintenance


## Renew SSL Certificate

```

_terraform1_cli

_terraform apply -target acme_certificate.certificate

NOTE: There is a problem with (module-tenant-canzea-cci.tf) 'data.vault_token' when the SSL is expired because the HTTP provider needs a valid SSL endpoint.

In this case, need to hardcode the vault token temporarily.

-- *.intg
terraform destroy -target module.workspace-intg.helm_release.dev-traefik
terraform apply -target module.workspace-intg.helm_release.dev-traefik
terraform apply -target module.workspace-intg.digitalocean_record.cluster

-- *.cloud
terraform apply -target module.saas-providers.helm_release.dev-traefik

-- *.ops
terraform taint -module=cd-bootstrap null_resource.install-ssl
terraform apply -target module.cd-bootstrap.null_resource.install-ssl

```
