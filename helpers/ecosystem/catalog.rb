require 'json'

puts JSON.generate({"branch" => ENV['CATALOG_BRANCH'], "commitRevision" => ENV['CATALOG_COMMIT']})
