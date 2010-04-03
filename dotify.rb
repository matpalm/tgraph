#!/usr/bin/env ruby
puts 'graph {'
puts 'graph [ overlap="false" ];'
STDIN.each do |line|
  a,b = line.strip.split "\t"
  puts "\"#{a}\"--\"#{b}\""# [penwidth=\"#{count}\"]"
end
puts "}"
