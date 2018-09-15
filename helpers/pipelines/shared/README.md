# Command Guide

Usage in Go.CD Pipelines:

````

/usr/bin/python
  shared/command.py
  create-docker
  up
  oss-index-deploy
  live-app-a-01-oss-index

Working directory: es-catalog/ecosystems/esff51/components

````

Steps:
- shared/prepare-env-vars.py
- shared/command.py plus-service-discovery-service
- shared/command.py graceful-shutdown
- shared/command.py create-docker
- shared/command.py register-service
- shared/command.py graceful-shutdown

Environment Variables:
- GW_URL : Flows Gateway URL
- GW_TOKEN : Bearer Token to access the flows gateway
- DEPLOY_ID : Needs to match the 'service'

## prepare-env-vars

- Find out what is live and prepare a plan specific to this build
- The plan will state what instances should be brought up and which brought down
- Choose "release-A" or "release-B" for UP or DOWN
- uses Consul to determine the two releases

| Argument | Description |
|---|---|
| service | Service |
| idBase | Prefix |
| new_tag | New tag to be updated on Consul service registry (i.e./ release) |
| ports.. | List of all ports - first half is A, second is B |


````
  TBD
  Creates a file like:
    prefix: 'live-app-01-oss-index'
    up: [3001,3002]
    down: [3003,3004]
````


## plus-service-discovery-service

- Executes a process-resources for the services that we want on Consul
- orchestrator resources.json

| Argument | Description |
|---|---|
| filter | which services to pick for shutdown - up or down or all |
| service | Service |
| ip | IP Address of the service that is being added |
| idBase | Prepended to the port to represent the service name on Consul |
| healthPath | Health path |
| ports... | Ports Auto-populated by command.py based on filter |


````
python plus-service-discovery-service.py oss-index 192.158.0.1 live-app-a-01-oss-index 3001 3002 3003 3004
````

## graceful-shutdown

- gracefully shutdown any of the instances based on 'filter'
- Cleanup any docker instance
- De-register systemd service
- health-check critical /[ID...]

| Argument | Description |
|---|---|
| filter | which services to pick for shutdown - up or down or all |
| idBase | Prepended to the port to represent the service name on Consul |
| ports... | Ports Auto-populated by command.py based on filter |

````
python graceful-shutdown.py live-app-01-oss-index 3001 3002
````

## create-docker

- Creates a docker instance for each item in the "UP" list
- create-docker /[ID...] /[Port...]

| Argument | Description |
|---|---|
| filter | which services to pick for docker creation - up or down or all |
| dockerImage | Name of the docker image |
| idBase | Prepended to the port to represent the service name on Consul |
| internalPort | Internal port that the service is listening to
| dockerArgs | Single string containing the docker args
| ports... | Ports Auto-populated by command.py based on filter |

## register-service

- Registers service for this particular instance
- register-service /[ID...]
- health-check passed /[ID...]

````
python register-service.py oss-index-deploy live-app-01-oss-index 3001 3002
````

| Argument | Description |
|---|---|
| filter | which services to pick for systemd registration and starting - up or down or all |
| dockerImage | Name of the docker image |
| idBase | Prepended to the port to represent the service name on Consul |
| ports... | Ports Auto-populated by command.py based on filter |

## update-tags

service = sys.argv[1]
newTag = sys.argv[2]
newTagId = sys.argv[3]
serviceIdPrefix = sys.argv[4]


| Argument | Description |
|---|---|
| filter | which services to pick for systemd registration and starting - up or down or all |
| newTag | Ensures that any tag not starting with 'newTag' remains |
| newTagId | The new tag to add with format: newTag=newTagId |
| idBase | Prepended to the port to represent the service name on Consul |
| ports... | Ports Auto-populated by command.py based on filter |

