#!/bin/bash

cp prod-1/Files/etc/yum.repos.d/mongodb-org-3.2.repo /etc/yum.repos.d/mongodb-org-3.2.repo

yum -y install mongodb-org

# data stored: /var/lib/mongo

