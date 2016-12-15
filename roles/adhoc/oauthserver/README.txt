

canzea --util=gen-user oauthuser

su -l oauthuser -c "npm install oauth2-server express body-parser"

npm install express-oauth-server


curl -v -X POST http://192.81.214.211:3000/oauth/token -d "grant_type=password&client_id=thom&client_secret=nightworld&username=thomseddon&password=nightworld"

curl -v -X GET http://192.81.214.211:3000/ -H "Authorization: Bearer 26a4470de7f92d143fd82432ac2bfb44d8f450cb"





git clone https://github.com/manjeshpv/node-oauth2-server-implementation




git clone https://github.com/panva/node-oidc-provider.git oidc-provider

cd oidc-provider

npm install

node example

http://192.81.214.211:3000/.well-known/openid-configuration
