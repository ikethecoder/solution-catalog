require_relative '../gocd-client'

puts GoCDClient.findObject 'v2', 'agents', 'escd27-perf-app-01'
