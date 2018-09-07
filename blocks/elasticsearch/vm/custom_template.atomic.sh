curl -XPUT $ELASTICSEARCH_URL/_template/template_1 -d '{
    "template": "*",
    "settings": {
        "index.refresh_interval": "5s"
    },
    "mappings": {
        "_default_": {
            "_all": {
                "enabled": true
            },
            "dynamic_templates": [
                {
                    "string_fields": {
                        "match": "*",
                        "match_mapping_type": "string",
                        "mapping": {
                            "index": "not_analyzed",
                            "omit_norms": true,
                            "type": "string"
                        }
                    }
                }
            ],
            "properties": {
                "@version": {
                    "type": "string",
                    "index": "not_analyzed"
                },
                "geoip": {
                    "type": "object",
                    "dynamic": true,
                    "properties": {
                        "location": {
                            "type": "geo_point"
                        }
                    }
                }
            }
        }
    }
}'