FROM gocd/gocd-server:v17.11.0

RUN mkdir -p /godata/plugins/external && chown go:go /godata/plugins/external

USER go


RUN (cd /godata/plugins/external && curl -L -s -O https://github.com/matt-richardson/gocd-websocket-notifier/releases/download/0.4.2%2Bbuild.60/gocd-websocket-notifier.jar)

RUN (cd /godata/plugins/external && curl -L -s -O https://github.com/gocd-contrib/gocd-oauth-login/releases/download/v2.4/gitlab-oauth-login-2.4.jar)

USER root
