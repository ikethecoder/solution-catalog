require 'json'
require 'git'

parameters = JSON.parse(ARGV[0])

g = Git.open(parameters['path'])

branch = g.current_branch
commit = g.log[0]

g.remote('origin').fetch

stats = g.diff('origin/master', commit).stats

origin = g.gcommit('origin/master').sha

puts JSON.generate({"branch" => branch, "commitRevision" => commit, "date" => commit.date.strftime('%FT%T%:z'), "message" => commit.message, "author" => {"name" => commit.author.name, "email" => commit.author.email}, "stats":stats, "origin":origin })
