

# Authenticate with user/password to get token:

curl -v -u root:admin1admin -XPOST -d '{"name":"gogs"}' http://67.205.189.194:10080/api/v1/users/root/tokens -H "Content-Type: application/json"

curl -v -u root:admin1admin http://174.138.36.126:10080/api/v1/users/aidancope/tokens -X POST -d '{"name":"gogs"}' -H "Content-Type: application/json"

# Store the token

# List Repositories

curl -v http://174.138.36.126:10080/api/v1/user/repos -H "Authorization: token 5bb33ed64056b7ea6035c83edce6421274649e63"

# Create Repository

curl -v -H "Authorization: token cf0f98e69f8fc1ea3c7dc56ca1afb62d5c0a167a" http://174.138.36.126:10080/api/v1/user/repos -X POST -d '{"name":"ecosystem-config", "description":"Configuration for the Ecosystem"}' -H "Content-Type: application/json"



# Signup for Admin should be done with a first-login.rb script.
