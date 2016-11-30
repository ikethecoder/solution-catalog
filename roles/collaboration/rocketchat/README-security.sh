

# Register User
# (NOT NEEDED) Administration / Integration / Incoming WebHook (Save and get URL)


# Authenticate to get token
curl http://localhost:8780/api/login -d "password=botbot1&user=Bot"

# Get list of public rooms
curl -H "X-Auth-Token: Yj92zZoTUt4BUCj-UOzvon03B94fXw11NckMS9CGUbt" -H "X-User-Id: 89c6iptmyGKu7Lb4m" http://localhost:8780/api/publicRooms

# Send message to room
curl -H "X-Auth-Token: NEuN15QYmwnIJEKT4tuOxnANDRO6FUmwXZo1WONb6xf" -H "Content-Type: application/json" -X POST -H "X-User-Id: 3r86vnhXK4pkvrSrP" http://localhost:8780/api/rooms/qZABht5GeFutrDqTq/send -d "{ \"msg\" : \"OK\" }"

# Bulk Create room, requires at least 2 members
curl -H "X-Auth-Token: NEuN15QYmwnIJEKT4tuOxnANDRO6FUmwXZo1WONb6xf" -H "Content-Type: application/json" -X POST -H "X-User-Id: 3r86vnhXK4pkvrSrP" http://localhost:8780/api/bulk/createRoom -d "{ \"rooms\": [ {\"name\":\"aslive\", \"members\":[\"Bot\",\"aidan\"] } ] }"

# Bulk register user
curl -H "X-Auth-Token: Yj92zZoTUt4BUCj-UOzvon03B94fXw11NckMS9CGUbt" -H "Content-Type: application/json" -X POST -H "X-User-Id: 89c6iptmyGKu7Lb4m" http://localhost:8780/api/bulk/register -d "{ \"users\": [ {\"name\":\"joe\", \"pass\":\"joejoe11\", \"email\":\"joe@name.com\"} ] }"


# Using web hooks (no authentication required)
# curl -X POST --data-urlencode 'payload={"text":"Deployed successfully <B>Dude</B>","attachments":[{"title":"Rocket.Chat","title_link":"https://rocket.chat","text":"Rocket.Chat, the best open source chat","image_url":"https://rocket.chat/images/mockup.png","color":"#764FA5"}]}' http://104.236.136.167:8780/hooks/9eCdZRQM2p9e4PAsk/YHiFu4cPPeCjMGXKk/BFMbfky7K2sNtRVxhtizT%2B9L4hJUaS4kO1U9W11ZwiA%3D
# curl -X POST --data-urlencode 'payload={"text":"Deployed successfully <B>Dude</B>"}' http://104.236.136.167:8780/hooks/3HtcLaJgKuPcTt5G7/3r86vnhXK4pkvrSrP/%2FGFxTWk8ljnp1DAyU3zR%2BNGM%2BqcL%2F2pxpDSGPsZB%2FkQ%3D

# "Highlights" will have special desktop notifications
# curl -X POST --data-urlencode 'payload={"text":"Deployed @OK <B>Dude</B>"}' http://104.236.136.167:8780/hooks/3HtcLaJgKuPcTt5G7/3r86vnhXK4pkvrSrP/%2FGFxTWk8ljnp1DAyU3zR%2BNGM%2BqcL%2F2pxpDSGPsZB%2FkQ%3D



# curl -H "X-Auth-Token: euZFclt7XQn2aWmHkXYpfbAkTDbFS1_3M4cmokOE3I5" -H "X-User-Id: 3r86vnhXK4pkvrSrP"  -H "Content-Type: application/json" -X POST http://localhost:8780/api/rooms/qZABht5GeFutrDqTq/send -d "{ \"msg\" : \"OK\" }"

# curl -X POST --data-urlencode 'payload={"text":"Deployed @OK <B>Dude</B>"}' -H "X-Auth-Token: euZFclt7XQn2aWmHkXYpfbAkTDbFS1_3M4cmokOE3I5" -H "X-User-Id: 3r86vnhXK4pkvrSrP" http://104.236.136.167:8780/hooks/3HtcLaJgKuPcTt5G7/3r86vnhXK4pkvrSrP/%2FGFxTWk8ljnp1DAyU3zR%2BNGM%2BqcL%2F2pxpDSGPsZB%2FkQ%3D
