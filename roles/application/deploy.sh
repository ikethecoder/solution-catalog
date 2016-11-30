#!/bin/bash

pwd

env

export REPO_PORT=`etcdctl get /components/repository/primary/port`
export REPO_HOST=`etcdctl get /components/repository/primary/host`


# WARNING: WE HAD TO PUT IN SUDOERS "GO" BEING ABLE TO RUN SUDO COMMANDS WITHOUT PASSWORD
# BAD!!
sudo -E ruby env/environment/production/roles/application/install.rb
