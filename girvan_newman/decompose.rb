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
require 'core_extensions'

raise "decompose.rb <EDGES>" unless ARGV.length==1
EDGES_FILE = ARGV[0]

# dilemma: tarjan and allshortestpath want 'graph' representation
# just as a list of nodes. graph itself want's a graph as a hash
#
graph = Graph::nodes_from_stream File.open(EDGES_FILE)
#puts "GR #{graph.first.class}"
#puts graph.dump
graphs = Tarjan.new(graph).run
puts "GR #{graphs.collect{|g| g.class}.inspect}"

10.times do |n|
	puts "ITERATION #{n}"
	next_graphs = []
	graphs.each do |graph|
		puts "graph=#{graph.class}"
		if graph.size==1
			puts "single node, pass along"
			next_graphs << graph
		else
			puts "sub graph #{graph.size} nodes"
			betweenness_edges = AllShortestPaths.new(graph).run
			betweenness_edges.each do |candidate_edge_to_remove|
				puts "trialing removal of edge #{candidate_edge_to_remove}"
				graph.remove_edge candidate_edge_to_remove
				sub_graphs = Tarjan.new(graph).run
				sub_graph_sizes = sub_graphs.collect {|sg| sg.size}
				puts "sub_graph_sizes = #{sub_graph_sizes.inspect}"
				exit 0
			end
			
			next_graphs += sub_graphs
		end
	end
	graphs = next_graphs

	# bling
	puts ">>next_graphs"
	graphs.each do |graph|
		puts "\t>>graph"
		graph.sort! {|a,b| a.id <=> b.id }
		graph.each do |node|
			puts "\t\tNODE #{node.to_s}"
		end
	end
	puts "<<next_graphs"
end

#asp = AllShortestPaths.new graph.nodes
#asp.all_shortest_paths
#betweenness_edges = asp.most_travelled
#graph.remove_edges betweenness_edges



#asp.output_dot

# barplot(sort(table(scan("passes"))))

