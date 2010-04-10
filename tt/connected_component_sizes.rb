#!/usr/bin/env ruby
(1..16).each do |i|
  puts "echo \"#{i} \""
  puts "head -#{i*1000} result.all | ./connected_components.rb | sort -n | tail -10"
end
