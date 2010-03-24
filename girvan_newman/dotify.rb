#!/usr/bin/env ruby
puts "graph {"
STDIN.each do |line|
	line.strip!
	line =~ /(\d) (.*?)\|(.*)/
	count, a, b = $1,$2,$3
	puts "\"#{a}\"--\"#{b}\" [penwidth=\"#{count}\"]"
end
puts "}"
