
# Creates the admin user first time
curl -i --raw -XPOST http://104.236.136.167:9080/restServices/redbackServices/userService/createAdminUser -d @config/admin.json --header "Content-Type: application/json"


# Create user
curl -i --raw -u admin:adminadmin1 -XPOST http://localhost:9080/restServices/redbackServices/userService/createUser -d @config/user.json --header "Content-Type: application/json"

# Assign roles
curl -i --raw -u admin:adminadmin1 -XPOST http://104.236.136.167:9080/restServices/redbackServices/roleManagementService/updateUserRoles -d @config/user-roles.json --header "Content-Type: application/json"
