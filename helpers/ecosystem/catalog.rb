require 'json'
require 'git'
require 'canzea/config'

file = File.read('config.json')
Canzea::configure JSON.parse(file)

g = Git.open(Canzea::config[:catalog_location])

branch = g.current_branch
commit = g.log[0]

puts JSON.generate({"branch" => branch, "commitRevision" => commit, "date" => commit.date.strftime('%FT%T%:z'), "message" => commit.message, "author" => {"name" => commit.author.name, "email" => commit.author.email} })
