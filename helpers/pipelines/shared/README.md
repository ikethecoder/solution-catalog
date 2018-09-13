
**auto-register-services**

- Executes a process-resources for the services that we want on Consul
- orchestrator resources.json

````
python plus-service-discovery-service.py oss-index 192.158.0.1 live-app-a-01-oss-index 3001 3002 3003 3004
````

**prepare-environment-vars**

- Find out what is live and prepare a plan specific to this build
- The plan will state what instances should be brought up and which brought down
- Choose "release-A" or "release-B" for UP or DOWN

````
  TBD
  Creates a file like:
    prefix: 'live-app-01-oss-index'
    up: [3001,3002]
    down: [3003,3004]
````

**graceful-shutdown-for-new-service**

- gracefully shutdown any of the instances that are marked as "UP"
- graceful-shutdown \[ID...]
- Cleanup any docker instance in the "UP" list
- De-register systemd service
- health-check critical /[ID...]

````
python graceful-shutdown.py live-app-01-oss-index 3001 3002
````

**create-docker-instance**

- Creates a docker instance for each item in the "UP" list
- create-docker /[ID...] /[Port...]

````
python create-docker.py oss-index-deploy live-app-01-oss-index 3001 3002
````

**register-service**

- Registers service for this particular instance
- register-service /[ID...]
- health-check passed /[ID...]

````
python register-service.py oss-index-deploy live-app-01-oss-index 3001 3002
````

**graceful-shutdown-for-down-services**

- Shutdown the services that were the old version
- graceful-shutdown \[ID...]

````
python graceful-shutdown.py live-app-01-oss-index 3003 3004
````
