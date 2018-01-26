Temporarily removed:

        {
            "digitalocean_dns": {
                "${environmentId}-lb": {
                    "environment": "cd",
                    "droplet": "${instanceName}",
                    "domain-id": "${es.fqdn_id}",
                    "domain": "${es.fqdn}",
                    "a": {
                        "name": "${environmentId}-lb",
                        "address": "${d}{digitalocean_droplet.${instanceName}.ipv4_address}"
                    }
                }
            }
        },


While we fix the terraform issue where the digitalocean_droplet is not found because the
DNS entry is put in the 'cd' environment and the droplet is in a different module.