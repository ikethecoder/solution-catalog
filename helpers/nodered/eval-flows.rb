require 'json'
require 'digest'

parameters = JSON.parse(ARGV[0])

file = parameters['file']

data = JSON.parse(File.read(file))


# Do an MD5 checksum for each file; do a search in the library based on checksum
# If a match, then make a note of the version
# If not a match, then publish the new version, making a note of the version
