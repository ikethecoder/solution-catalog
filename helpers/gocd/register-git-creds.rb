require 'json'
require 'uri'

parameters = JSON.parse(ARGV[0])

uri = URI(parameters['url'])

cred = parameters['credential_resource']
cred.gsub! '-','_'
cred.upcase!

usernameKey = "#{cred}_USERNAME"
passwordKey = "#{cred}_PASSWORD"
fullGitCred = "#{uri.scheme}://#{ENV[usernameKey]}:#{ENV[passwordKey]}@#{uri.host}#{uri.path}"

lines = []
found = "new"

File.open("/var/local/gocd/home/.git-credentials", "r") do |f|
  f.each_line do |line|
    if line.include? fullGitCred
       found = "match"
       lines << line
    elsif line.include? "#{uri.host}#{uri.path}"
       found = "replace"
       lines << fullGitCred
    else
       lines << line
    end
  end
end

if found == "new"
  lines << fullGitCred
  puts "Credentials added for #{uri}"
elsif found == "replace"
  puts "Credentials replaced for #{uri}"
else
  puts "Credentials exist for #{uri}"
end

File.open("/var/local/gocd/home/.git-credentials", 'w') do |f|
  lines.each do |line|
    f.puts line
  end
end
