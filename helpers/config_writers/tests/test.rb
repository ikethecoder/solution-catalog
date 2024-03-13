require 'json'

puts "GO"

if ARGV[0].start_with?("@") then
    file = File.read(ARGV[0][1..-1])
    json = JSON.parse(file)
else
    json = JSON.parse(ARGV[0])
end

puts json