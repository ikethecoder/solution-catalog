#!/bin/bash

rm -f jdk-8u60-linux-x64.rpm

wget -nv --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u60-b27/jdk-8u60-linux-x64.rpm"

yum -y localinstall jdk-8u60-linux-x64.rpm

rm -f jdk-8u60-linux-x64.rpm

