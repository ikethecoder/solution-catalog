

#// Add the keyvalue for secure host
canzea --lifecycle=wire --solution=consul --action=add_keyvalue --args='{"key":"nodes/build-a-01/secure_host","value":"ese385.canzea.cc"}'

#// DNS Registration
canzea --lifecycle=wire --solution=digitalocean --action=register-dns --args='{"domain":"ese385","ip":"192.81.214.211","rootHost":"canzea.cc"}'

#// Add Digital Ocean secret
canzea --lifecycle=wire --solution=vault --action=register-secret --args='{"key":"digitalocean","data":{"token":"<token>"}}'

