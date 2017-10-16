#!/bin/bash

rm -f jdk.rpm

curl -s -L -o jdk.rpm -H "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://javadl.oracle.com/webapps/download/AutoDL?BundleId=220304_d54c1d3a095b4ff2b6607d096fa80163"

yum -y localinstall jdk.rpm

rm -f jdk.rpm




