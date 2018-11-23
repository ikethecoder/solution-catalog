FROM jboss/keycloak:4.1.0.Final

RUN ls -l keycloak/themes
RUN ( cd /tmp && git clone -b 4.1.0.Final https://github.com/keycloak/keycloak.git )
RUN ( cd /tmp && cp -r keycloak/examples/themes/src/main/resources/theme/* /opt/jboss/keycloak/themes/ )
RUN ls -l keycloak/themes

USER root
RUN yum install -y xmlstarlet

USER jboss
RUN xmlstarlet ed --inplace \
        -N x="urn:jboss:domain:undertow:3.0" \
        -a "//x:http-listener" \
        -t attr \
        -n 'proxy-address-forwarding' \
        -v 'true' \
        /opt/jboss/keycloak/standalone/configuration/standalone.xml