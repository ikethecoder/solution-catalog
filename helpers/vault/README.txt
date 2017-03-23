

security:vault:initialize:execute
security:vault:unseal:execute
security:vault:enableappid:execute
security:vault:addapplication:execute
security:vault:assocuser:execute
security:vault:authenticate:execute


canzea --lifecycle=wire --solution=vault --action=vault-init --args='{}'
(returns the keys, and root_token)

canzea --lifecycle=wire --solution=vault --action=vault-unseal --args='{"key":"4d456e930cb02da81cce89dee561d3ba5d5d4de67d34371f2dc9354f9ce8f8e8"}'
RETURNED: {"sealed":false,"t":1,"n":1,"progress":0}

export VAULT_TOKEN=00aec08b-c616-cca2-c9e2-f7b9ca5c5c65

canzea --lifecycle=wire --solution=vault --action=vault-enable-app-id --args='{}'


canzea --lifecycle=wire --solution=vault --action=vault-assoc-policy-to-app --args='{"appId":"1-2-3-4","policy":"ABC","displayName":"ABC App"}'

canzea --lifecycle=wire --solution=vault --action=vault-assoc-app-to-user --args='{"appId":"1-2-3-4","userId":"JoeUserId"}'

canzea --lifecycle=wire --solution=vault --action=vault-authenticate --args='{"appId":"1-2-3-4","userId":"JoeUserId"}'
{"lease_id":"","renewable":false,"lease_duration":0,"data":null,"warnings":null,"auth":{"client_token":"9123a699-8701-70cd-4d0a-cad24e447ea7","accessor":"3b71b10a-03c8-8a96-367c-743a8ca32b87","policies":["ABC","default"],"metadata":{"app-id":"sha1:39a957a3f07688f318187f75cefd65c2012e7f77","user-id":"sha1:8fade0c3ab5c4e19fc90672bf10b4de1213b15e0"},"lease_duration":2592000,"renewable":true}}


canzea --lifecycle=wire --solution=vault --action=get-secret --args='{"key":"abc","data":{"user":"joe"}}'
