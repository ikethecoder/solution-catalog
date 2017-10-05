require 'json'
require 'git'

g = Git.open(ENV['CATALOG_LOCATION'])

branch = g.current_branch
commit = g.log[0]

response = JSON.generate({"branch" => branch, "commitRevision" => commit, "date" => commit.date.strftime('%FT%T%:z'), "message" => commit.message, "author" => {"name" => commit.author.name, "email" => commit.author.email} })
puts response

File.open('info.json', 'w') { |file| file.write(response) }

