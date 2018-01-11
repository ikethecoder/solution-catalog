FROM golang:1.9-alpine as confd

ARG CONFD_VERSION=0.14.0

RUN apk add --no-cache git

RUN git clone https://github.com/kelseyhightower/confd.git /tmp/confd

RUN ls -l /tmp/confd

RUN apk add --no-cache \
    bzip2 \
    make && \
  mkdir -p /go/src/github.com/kelseyhightower/confd && \
  cd /go/src/github.com/kelseyhightower/confd && \
  cp -r /tmp/confd/* . && \
  go install && \
  rm -rf /tmp/confd.git

FROM tomcat:8.5.15-jre8-alpine

COPY --from=confd /go/bin/confd /usr/local/bin/confd

RUN adduser -u 1002 -D -H confd_agent

