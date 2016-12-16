require 'json'
require 'canzea'

parameters = JSON.parse(ARGV[0])

extraConfig = Canzea::config[:catalog_location] + "/env.json"

if (File.exists?(extraConfig))
    
end
