worker_processes  1;

pid        /var/run/nginx.pid;

events {
    worker_connections  128;
}


http {
    include       /conf/mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    resolver 127.0.0.11; # Docker DNS

    lua_package_path '/usr/local/openresty/lualib/?.lua;;';

    # cache for discovery metadata documents
    lua_shared_dict discovery 1m;
    # cache for JWKs
    lua_shared_dict jwks 1m;
    # lua_code_cache off;

    lua_ssl_trusted_certificate /etc/ssl/certs/ca-certificates.crt;
    lua_ssl_verify_depth 5;

    server {
        listen       80;
        server_name  consul.{{ES_DOMAIN}};

        location / {

            access_by_lua '

                local opts = {
                    redirect_uri = "https://consul.{{ES_DOMAIN}}/redirect_uri",
                    discovery = "{{OAUTH_CLIENTS_GITEA_OIDC_DISCOVERY}}",
                    client_id = "gitea",
                    client_secret = "{{OAUTH_CLIENTS_GITEA_CLIENT_SECRET}}",
                    -- redirect_uri_scheme = "https",
                    scope = "openid profile",
                    logout_path = "/logout",
                    redirect_after_logout_uri = "{{OAUTH_CLIENTS_GITEA_OIDC_ISSUER}}/protocol/openid-connect/logout?redirect_uri=https%3A%2F%2Fconsul.{{ES_DOMAIN}}",
                    redirect_after_logout_with_id_token_hint = false,
                    session_contents = {id_token=true,access_token=true},
                    ssl_verify = "no"
                }

                function dump(o)
                    if type(o) == "table" then
                        local s = "{ "
                        for k,v in pairs(o) do
                            if type(k) ~= "number" then k = " "..k.." " end
                            s = s .. "["..k.."] = " .. dump(v) .. ","
                        end
                        return s .. "} "
                    else
                        return tostring(o)
                    end
                end

                -- call introspect for OAuth 2.0 Bearer Access Token validation
                local res, err = require("resty.openidc").authenticate(opts)

                if err then
                    ngx.status = 403
                    ngx.say(err)
                    ngx.exit(ngx.HTTP_FORBIDDEN)
                end

                ngx.req.set_header("x-user-email", res.id_token.email);
                ngx.req.set_header("x-user-preferred-username", res.id_token.preferred_username);
                ngx.req.set_header("x-access-token", res.access_token);

                print(dump(ngx.req))
            ';

            root   /www;
            index  index.html index.htm;

            proxy_ssl_certificate     /ssl/consul.cert;
            proxy_ssl_certificate_key /ssl/consul.key;
            proxy_ssl_trusted_certificate /ssl/ca.cert;
            proxy_ssl_verify       on;
            proxy_ssl_session_reuse on;

            proxy_ssl_protocols           TLSv1 TLSv1.1 TLSv1.2;
            proxy_ssl_ciphers             HIGH:!aNULL:!MD5;

            proxy_pass https://consul.service.dc1.consul:8080;
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection 'upgrade';
            proxy_set_header Host $host;
            proxy_cache_bypass $http_upgrade;
            proxy_set_header X-Real-IP $remote_addr;

        }


    }
}