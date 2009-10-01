#!/usr/bin/env ruby
require 'set'


class AllShortestPaths

	def initialize neighbours
		@neighbours = neighbours
		@shortest_path_edges = {}
		@shortest_path_edges.default = 0
	end
		
	def output_dot
		dot = File.open("test.dot","w")
		dot.puts "digraph {"
		@neighbours.each do |from,neighbour_list|
			neighbour_list.each do |neighbour|
				dot.puts "#{from} -> #{neighbour} [penwidth=\"#{@shortest_path_edges[[from,neighbour]]}\"]"
			end
		end
		dot.puts "}"
		dot.close
	end

	def all_shortest_paths
		@neighbours.keys.each { |k| shortest_path_from k }
		@shortest_path_edges.values.each { |v| puts v }
	end

	def shortest_path_from start_node
		backtrack = {}

		queue = []
		queue << start_node

		#distances = {}
		#distances.default = 1.0/0
		#distances[start_node] = 0

		visited = Set.new
		shortest_found = Set.new
		shortest_found << start_node

		while !queue.empty?
			node = queue.shift
			visited << node
			next unless @neighbours.has_key? node
			@neighbours[node].each do |neighbour|
				if (!shortest_found.include? neighbour)
					@shortest_path_edges[[node,neighbour]] += 1
					shortest_found << neighbour
				end
				queue << neighbour unless visited.include?(neighbour) || queue.include?(neighbour)
			end
		end
		
	end

end

=begin
neighbours = {
0=>[1,3],
1=>[2],
2=>[6,5,4,3],
3=>[4],
4=>[],
5=>[8,9,4,0],
6=>[1,7,8,5],
7=>[8,4],
8=>[9],
9=>[4,0],
10 => [11],
11 => [12],
12 => [10],
}
=end

raise "all_shortest_paths.rb <EDGES>" unless ARGV.length==1
EDGES_FILE = ARGV[0]

neighbours = {}
File.open(EDGES_FILE).each do |edge|
	from,to = edge.strip.split("\t")
	neighbours[from] ||= []
	neighbours[from] << to	
end
#puts neighbours.inspect

asp = AllShortestPaths.new neighbours
asp.all_shortest_paths
#asp.output_dot

# barplot(sort(table(scan("passes"))))

