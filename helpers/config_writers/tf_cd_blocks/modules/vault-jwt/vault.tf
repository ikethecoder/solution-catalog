resource "null_resource" "vault-jwt" {

  connection {
    host = "${var.base_proxy_ipv4_address}"
    user = "root"
    type = "ssh"
    private_key = "${var.pvt_key_data}"
    timeout = "2m"
  }
 
  provisioner "remote-exec" {
    inline = [
        "export _READY_HACK=${var.module_depends_on}",
        "set -e && set -v",
        ". ./profile.d.sh",
        "vault status",
        "vault write auth/jwt/config oidc_discovery_url='${var.oidc_discovery_url}'"
    ]
  }
}

/*

(1) Create a CLIENT: AccessType = public


 curl -v -X POST https://auth.cloud.184768.xyz/auth/realms/operations/protocol/openid-connect/token -d grant_type=password -d client_id=direct -d client_secret="0dc30955-a9cb-4a0f-a358-52f8d5ef74ef" -d username="joe" -d password="joe" -d scope="offline_access openid"

(2) Create appropriate policies

path "secret/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

vault policy write all ./all.policy

(3) create a role for the jwt authentication

vault delete auth/jwt/role/demo 
vault write auth/jwt/role/demo \
    bound_audiences="account" \
    user_claim="preferred_username" \
    policies=all \
    ttl=1h

(4) Login, and use the token to call the ProviderGW API

vault write auth/jwt/login role=demo jwt="eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJHWFFEVmx4WDFoQTV0X3FpMS1JZXVXMXVndUNqSFZPbzJ3dUYxdHFvX0ZvIn0.eyJqdGkiOiIwYTE0YzZhOS05MzExLTQ1NTItOTNlMy0xNjQ4NmFlMzRiNjkiLCJleHAiOjE1NTA3OTU4NzcsIm5iZiI6MCwiaWF0IjoxNTUwNzk1NTc3LCJpc3MiOiJodHRwczovL2F1dGguY2xvdWQuMTg0NzY4Lnh5ei9hdXRoL3JlYWxtcy9vcGVyYXRpb25zIiwiYXVkIjoiYWNjb3VudCIsInN1YiI6ImNmNWQ3YjM2LTczMjEtNDZhOC1iMDdkLTNjZDBiZGJlZjExYiIsInR5cCI6IkJlYXJlciIsImF6cCI6ImRpcmVjdCIsImF1dGhfdGltZSI6MCwic2Vzc2lvbl9zdGF0ZSI6IjQ1NDEzMWVkLWZlMGUtNDQ5MC1hOWIwLWU3M2VhY2M1YmVmOSIsImFjciI6IjEiLCJhbGxvd2VkLW9yaWdpbnMiOlsiaHR0cHM6Ly8qIl0sInJlYWxtX2FjY2VzcyI6eyJyb2xlcyI6WyJvZmZsaW5lX2FjY2VzcyIsInVtYV9hdXRob3JpemF0aW9uIl19LCJyZXNvdXJjZV9hY2Nlc3MiOnsiYWNjb3VudCI6eyJyb2xlcyI6WyJtYW5hZ2UtYWNjb3VudCIsIm1hbmFnZS1hY2NvdW50LWxpbmtzIiwidmlldy1wcm9maWxlIl19fSwic2NvcGUiOiJvcGVuaWQgcHJvZmlsZSBvZmZsaW5lX2FjY2VzcyBlbWFpbCIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJuYW1lIjoiSm9lIFNtaXRoIiwicHJlZmVycmVkX3VzZXJuYW1lIjoiam9lIiwiZ2l2ZW5fbmFtZSI6IkpvZSIsImZhbWlseV9uYW1lIjoiU21pdGgiLCJlbWFpbCI6ImpvZUBnbWFpbC5jb20ifQ.arXThDY5qCddsylPlhKkySFiUQz-DFrsQfeyZmge1aI6Joeru1miGWkUf_m4NHI_WFLpbqRh4WXiZr1aZyZf6RZB77EtI6R-qQDMqKrmzaDTSiNtT_IYM_WaJc1pzea6pAerWVl6SdL6SSN_fSHdbNQDj2xkBQQF68RwLrAJklFsjsJpCsyrcCM6_4rEXZC8Dbd7yKLpYN9BdnqbwtIyWOMubKxP01osNOOpDdX17JXo58Ajh7z0c5Gbysn4cU5VJ5bg-yh6CiB70LzaUw897r4d-RrP3namcH4gfQqVrLzduTFoZNfp1wF3oOd7tNAwuBHeEBquvxXD6MGjj6Lt4w"



curl \
    --request POST \
    --data '{"jwt": "eyJhbGciOiJIUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJmZmYyMmMxNy1jYWNkLTQ2MjQtYTllZC05NzczYTY2MGNlNWUifQ.eyJqdGkiOiJiOTQ3YmIwZi02ZDIwLTRiM2EtOGRkNy1lNTdlYjkxN2EzMWEiLCJleHAiOjE1NTA4MjI2NTUsIm5iZiI6MCwiaWF0IjoxNTUwNzg2NjU1LCJpc3MiOiJodHRwczovL2F1dGguY2xvdWQuMTg0NzY4Lnh5ei9hdXRoL3JlYWxtcy9vcGVyYXRpb25zIiwic3ViIjoiY2Y1ZDdiMzYtNzMyMS00NmE4LWIwN2QtM2NkMGJkYmVmMTFiIiwiYXV0aF90aW1lIjowLCJzZXNzaW9uX3N0YXRlIjoiOWMwMzg0NTUtZDI0ZS00Y2E1LTg4YzctNGJmNjFiZTBlY2I3Iiwic3RhdGVfY2hlY2tlciI6Ik9iMDY1bEc5bm42UXNVYUdoaGZ3X0w0UF9Ib0xUd2lreGNickpBTTYtOTAifQ.V2Pkhn9ldDd22hNbOPPVT_bJNAl8seHrQEqMReSRh1E", "role": "demo"}' \
    http://127.0.0.1:8200/v1/auth/jwt/login

*/