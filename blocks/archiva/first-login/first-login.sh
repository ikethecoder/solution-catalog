#!/bin/bash

set -e


docker run --net=host --rm \
  -v $CATALOG_LOCATION/blocks/archiva/first-login/scripts:/tests \
  -e ENV=local \
  -e PHANTOMJS_URL \
  -e SERVICE_ARCHIVA_ESADMIN_CREDENTIALS_URL \
  -e SERVICE_ARCHIVA_ESADMIN_CREDENTIALS_EMAIL \
  -e SERVICE_ARCHIVA_ESADMIN_CREDENTIALS_USER_NAME \
  -e SERVICE_ARCHIVA_ESADMIN_CREDENTIALS_PASSWORD \
  canzea ruby /tests/first-login.rb
