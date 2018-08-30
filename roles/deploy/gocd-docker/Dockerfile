FROM gocd/gocd-server:v18.7.0

RUN mkdir -p /godata/plugins/external && \
    curl --location --fail https://github.com/gocd/docker-registry-artifact-plugin/releases/download/1.0.0/docker-registry-artifact-plugin-1.0.0-3.jar > /godata/plugins/external/docker-registry-artifact-plugin-1.0.0-3.jar && \
    curl --location --fail https://github.com/matt-richardson/gocd-websocket-notifier/releases/download/0.4.2%2Bbuild.60/gocd-websocket-notifier.jar > /godata/plugins/external/gocd-websocket-notifier-0.4.2.jar

COPY generic-oauth-authorization-plugin-1.0.0-0.jar /godata/plugins/external/generic-oauth-authorization-plugin-1.0.0-0.jar

RUN chown -R 1000 /godata/plugins/external
