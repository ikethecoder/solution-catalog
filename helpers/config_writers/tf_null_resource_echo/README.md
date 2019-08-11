

# Resource

```
resources:
- tf_null_resource_echo:
    ${instance.id}-hello:
      environment: ${environment.id}
      name: Marie
```
