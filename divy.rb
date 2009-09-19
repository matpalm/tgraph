#!/usr/bin/env ruby
STDIN.each do |line|
	cols = line.split "\t"
	source_node = cols[0]
	puts "#{source_node}\t0"
	nodes = cols[1].split
	page_rank = cols[3].to_f
	divyed_page_rank = page_rank / nodes.size
	nodes.each { |node| puts "#{node}\t#{divyed_page_rank}" }
end
