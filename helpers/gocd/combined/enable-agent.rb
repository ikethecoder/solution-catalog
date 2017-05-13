require_relative '../gocd-client'

puts GoCDClient.findObject '4', 'agents', 'escd27-perf-app-01'
