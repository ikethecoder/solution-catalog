
canzea --lifecycle=wire --solution=vault --action=register-secret --args='{"key":"certs/letsencrypt/privkey", "file":"/etc/letsencrypt/archive/{{ECOSYSTEM}}.canzea.cc/privkey1.pem"}'

canzea --lifecycle=wire --solution=vault --action=register-secret --args='{"key":"certs/letsencrypt/fullchain", "file":"/etc/letsencrypt/archive/{{ECOSYSTEM}}.canzea.cc/fullchain1.pem"}'
