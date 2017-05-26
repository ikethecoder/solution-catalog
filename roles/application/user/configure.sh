#!/bin/bash

adduser -m appuser

export TMP_PASSWORD=appuser1; expect roles/application/user/set-password.expect appuser

sudo -E -u appuser expect roles/application/user/key-gen.expect

# sudo -E -u appuser expect Security/copy-to-server-1.expect

mkdir -p /opt/applications/working

groupadd appgrp

# Have go:go as the primary user
chown -R go:appgrp /opt/applications

chown -R appuser:appgrp /opt/applications/working

