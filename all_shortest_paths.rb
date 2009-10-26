#!/usr/bin/env ruby
require 'set'
require 'node'
require 'graph'

class Node
	attr_accessor :found_shortest, :visited
end

class AllShortestPaths

	def initialize nodes
		@nodes = nodes
		@nodes.each { |n| n.found_shortest = n.visited = false }
	end
			
	def output_dot
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

	def run
		@shortest_path_edges = {}
		@shortest_path_edges.default = 0
		@nodes.each do |k|
			shortest_path_from k 
		end
		most_travelled
	end

	def shortest_path_from start_node
		queue = []
		queue << start_node
		start_node.found_shortest = true
		while !queue.empty?
			node = queue.shift
			node.visited = true
			node.neighbours.each do |neighbour|
				if !neighbour.found_shortest
					@shortest_path_edges[[node, neighbour]] += 1
					neighbour.found_shortest = true
				end
				queue << neighbour unless neighbour.visited || queue.include?(neighbour)
			end
		end
	end

	def most_travelled
		max_value = 0
		max_edge = []
		@shortest_path_edges.each do |k,v|
#			puts "#{k.first.id} #{k.last.id} #{v}"
			if v == max_value
				max_edge << k
			elsif v > max_value
				max_value = v
				max_edge = [k]
			end
		end
		edge_ids = max_edge.collect { |pair| [pair.first.id, pair.last.id] }
		puts "max_edge #{edge_ids.inspect}"
		edge_ids
	end

end


