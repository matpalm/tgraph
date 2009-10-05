#!/usr/bin/env ruby
require 'set'
require 'node'

class Node

	attr_accessor :found_shortest, :visited

	def reset
		@found_shortest = @visited = false
	end

end

class AllShortestPaths

	def initialize nodes
		@nodes = nodes
	end
		
	def output_dot # move to Node
		dot = File.open("test.dot","w")
		dot.puts "digraph {"
		@nodes.each do |node|
			node.neighbours.each do |neighbour|
				number_times_edge_crossed = @shortest_path_edges[[node, neighbour]]
				width = number_times_edge_crossed#Math.log(number_times_edge_crossed+1)
				puts "\"#{node.id}\" -> \"#{neighbour.id}\" [penwidth=\"#{width}\"]"
				dot.puts "\"#{node.id}\" -> \"#{neighbour.id}\" [penwidth=\"#{width}\"]"
			end
		end
		dot.puts "}"
		dot.close
	end

	def all_shortest_paths
		@shortest_path_edges = {}
		@shortest_path_edges.default = 0
		@nodes.each do |k|
			@nodes.each { |n| n.reset }
			shortest_path_from k 
		end
	end

	def shortest_path_from start_node
		backtrack = {}

		queue = []
		queue << start_node

		start_node.found_shortest = true

		while !queue.empty?
			node = queue.shift
			node.visited = true
#			next unless node.neighbours.include? node
			node.neighbours.each do |neighbour|
				if !neighbour.found_shortest
					@shortest_path_edges[[node, neighbour]] += 1
					neighbour.found_shortest = true
				end
				queue << neighbour unless neighbour.visited || queue.include?(neighbour)
			end
		end
		
	end

end

raise "all_shortest_paths.rb <EDGES>" unless ARGV.length==1
EDGES_FILE = ARGV[0]

nodes = Node.hash_to_nodes_from_file EDGES_FILE
#puts neighbours.inspect

asp = AllShortestPaths.new nodes
asp.all_shortest_paths
asp.output_dot

# barplot(sort(table(scan("passes"))))

