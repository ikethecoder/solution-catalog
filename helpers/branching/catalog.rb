require 'json'

puts JSON.generate({"branch" => ENV['CATALOG_BRANCH'], "commit" => ENV['CATALOG_COMMIT']})
