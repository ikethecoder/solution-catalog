require 'json'
require 'git'

g = Git.open(ENV['CATALOG_LOCATION'])

branch = g.current_branch
commit = g.log[0]

puts JSON.generate({"branch" => branch, "commitRevision" => commit, "date" => commit.date.strftime('%FT%T%:z'), "message" => commit.message, "author" => {"name" => commit.author.name, "email" => commit.author.email} })
