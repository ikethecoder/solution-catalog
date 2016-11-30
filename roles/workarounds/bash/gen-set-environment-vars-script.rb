require 'json'

out = File.open(ENV['HOME'] + '/.bash_ike', 'w')

out.puts "alias gitreset='git fetch --all; git reset --hard origin/master'"
out.puts "alias trace='ruby ../init/trace.rb $*'"

out.puts "export HOST_1=`curl -s http://169.254.169.254/metadata/v1/hostname`"
out.puts "export IP_1_PRIVATE=`curl -s http://169.254.169.254/metadata/v1/interfaces/private/0/ipv4/address`"
out.puts "export IP_1_PUBLIC=`curl -s http://169.254.169.254/metadata/v1/interfaces/public/0/ipv4/address`"

out.puts "export LISTENER_PRV=`curl -s http://169.254.169.254/metadata/v1/interfaces/private/0/ipv4/address`"
out.puts "export LISTENER_PUB=`curl -s http://169.254.169.254/metadata/v1/interfaces/public/0/ipv4/address`"
out.puts "export LISTENER_LOC=127.0.0.1"
out.puts "export LISTENER_VPN=TBD"

puts "Created .bash_ike in " + ENV['HOME']
