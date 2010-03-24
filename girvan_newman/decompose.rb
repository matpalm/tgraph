#!/usr/bin/env ruby

class Array
	def random_elem
		self[rand()*size]
	end
	def min_elem
		self.inject { |a,v| v[0] <= a[0] && v[1] <= a[1] ? v : a }
	end
end

require 'all_shortest_paths'
require 'tarjans_scc'

raise "decompose.rb <EDGES>" unless ARGV.length==1
EDGES_FILE = ARGV[0]

graph = Graph.nodes_from_file EDGES_FILE
puts "GR #{graph.class}"
puts graph.dump
graphs = Tarjan.new(graph.nodes).run
puts "GR #{graphs.first.class}"

10.times do |n|
	puts "ITERATION #{n}"
	next_graphs = []
	graphs.each do |g|
		puts "g=#{g}"
		if g.single_node?
			puts "single node, pass along"
			next_graphs << g
		else
			puts "sub graph #{graph.dump}"
			betweenness_edges = AllShortestPaths.new(graph.nodes).run
			edge_to_remove = betweenness_edges.random_elem
			puts "removing #{edge_to_remove.inspect}"
			graph.remove_edges [edge_to_remove]
			puts graph.dump
			sub_graphs = Tarjan.new(graph.nodes).run
			next_graphs += sub_graphs
		end
	end
	graphs = next_graphs
end

#asp = AllShortestPaths.new graph.nodes
#asp.all_shortest_paths
#betweenness_edges = asp.most_travelled
#graph.remove_edges betweenness_edges



#asp.output_dot

# barplot(sort(table(scan("passes"))))

