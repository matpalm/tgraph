#!/usr/bin/env ruby
require 'rubygems'
require 'rgl/adjacency'
require 'rgl/connected_components'
require 'parse'
require 'shortest_path'
require 'core_extensions'

g = parse_from_stdin

5.times do |i|
	maximal_edges = g.maximal_between_edges
	puts "maximal_edges=#{maximal_edges.inspect}"

	candidate_solutions = Solutions.new
	maximal_edges.edges.each do |candidate_edge_to_remove|
		puts "trialing candidate_edge_to_remove=#{candidate_edge_to_remove.inspect}"

		g.remove_edge *(candidate_edge_to_remove)

		sizes = []
		g.each_connected_component do |vertexs| 
			sizes << vertexs.size
			# note: to build a graph from this list can clone original
		  #       graph and then remove all vertices BUT these ones
		end
		candidate_solutions.add candidate_edge_to_remove, sizes

		g.add_edge *(candidate_edge_to_remove)

	end

	puts candidate_solutions.solutions
	exit 0
end

puts "final"
g.each_connected_component do |vertexs| 
	puts vertexs.inspect
end
