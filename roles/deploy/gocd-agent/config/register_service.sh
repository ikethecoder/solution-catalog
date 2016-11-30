#!/usr/bin/ruby

require 'pathname'

fileIn = ARGV[1]
service = ARGV[0]

file = "#{service}.service"

contents = File.read "#{fileIn}"

File.write "/etc/systemd/system/multi-user.target.wants/#{file}", contents

puts "Wrote: /etc/systemd/system/multi-user.target.wants/#{file}"
system ("systemctl daemon-reload")

system ("systemctl restart #{service}")