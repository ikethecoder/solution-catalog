
# For parsing JSON
yum -y install jq

curl -L http://104.236.136.167/api/v3/users?private_token=SQNjo1xsruyhbwben9Hk

# Creates a user: joe
curl -L -X POST http://104.236.136.167/api/v3/users?private_token=SQNjo1xsruyhbwben9Hk -d "email=aidan.cope@gmail.com&name=Joe&username=joe&password=joejoe11"

# Create project
curl -L -X POST http://104.236.136.167/api/v3/projects?private_token=SQNjo1xsruyhbwben9Hk -d "name=shit&public=true"

# Create project for user
curl -L -X POST http://104.236.136.167/api/v3/projects/user/2?private_token=SQNjo1xsruyhbwben9Hk -d "name=shit&public=true"

# Add member user to project
curl -L http://104.236.136.167/api/v3/projects/4/members?private_token=SQNjo1xsruyhbwben9Hk

# Create a hook
curl -L -X POST http://104.236.136.167/api/v3/projects/4/hooks?private_token=SQNjo1xsruyhbwben9Hk -d "id=shit&url=http://blah&push_events=true&enable_ssl_verification=true"

# Login to get private token
curl -L -X POST http://104.236.136.167/api/v3/session -d "login=joe&password=joejoe11"

PRIVATE_TOKEN=`curl -L -s -X POST http://104.236.136.167/api/v3/session -d "login=joe&password=joejoe11"  | jq -r '.private_token'`

Hook:
http://104.236.136.167:8153/go/api/material/notify/git/?repository_url=Sample
