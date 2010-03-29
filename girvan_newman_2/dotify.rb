#!/usr/bin/env ruby
puts "graph {"
STDIN.each do |line|
  a,b = line.strip.split "\t"
  puts "\"#{a}\"--\"#{b}\""# [penwidth=\"#{count}\"]"
end
puts "}"
