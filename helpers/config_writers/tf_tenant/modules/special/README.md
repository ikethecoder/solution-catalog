# Setup
```

module "special" {
    source = "./modules/tenants/special"

    es_id = "${var.es_id}"
    domain_name = "${var.domain_name}"

    vault_token = "${data.http.root_token.body}"

    namedotcom = "${var.all_providers["namedotcom"]}"
    stripe = "${var.all_providers["stripe"]}"
    s3 = "${var.all_providers["s3"]}"

    tenant_id = "cci"
}

variable all_providers {
    type = "map"
}
```
