require 'stringio'

pattern = ARGV[1]

output =StringIO.new
File.open(ARGV[0]).each do |line|
	if (line.scan(pattern).length > 0)
		puts "Skipping #{line}"
	else
		output.puts line
	end
end
File.write(ARGV[0], output.string)
