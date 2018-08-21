#!/bin/bash

export HOSTNAME=test-hostname
export ECOSYSTEM=test-es

export _PWD=`pwd`

unset ECOSYSTEM_CONFIG_GIT

mkdir -p $TMPDIR/tests

cd $TMPDIR/tests

rm $PWD/sc/ecosystems/test-es/terraform/modules/cd/*

echo "Output at $PWD"
ruby $_PWD/digitalocean_droplet.rb @$_PWD/samples/digitalocean_droplet.json PLUS

ruby $_PWD/terraform_module.rb @$_PWD/samples/terraform_module.json PLUS
ruby $_PWD/digitalocean_firewall.rb @$_PWD/samples/digitalocean_firewall.json PLUS


echo "Output at $PWD/sc/ecosystems/test-es/terraform/modules/cd"
cat $PWD/sc/ecosystems/test-es/terraform/modules/cd/*
ls -l $PWD/sc/ecosystems/test-es/terraform/modules/cd
