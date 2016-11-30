#!/usr/bin/expect

spawn htpasswd -c /etc/nginx/htpasswd.users kibanaadmin
expect "New password:"
send "pass\r"
expect "new password:"
send "pass\r"
expect
