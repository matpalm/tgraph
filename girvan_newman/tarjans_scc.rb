#!/usr/bin/env ruby
# tarjans strongly connected components algorithm

require 'node'
require 'graph'

class Node
	attr_accessor :index, :low_link
end

class Tarjan
	attr_reader :sub_graphs

	def initialize nodes
		@nodes = nodes
		@nodes.each { |n| n.index = n.low_link = nil }
		@index = 0
		@stack = []
		@sub_graphs = []
	end
	
	def min a, b
		a < b ? a : b
	end

	def run
		@nodes.each do |node|
			tarjan(node) if node.index.nil?
		end
		@sub_graphs
	end
	
	def tarjan node
		node.index = node.low_link = @index
		@index += 1
		@stack.unshift node
		node.neighbours.each do |neighbour|
			if neighbour.index.nil?
				tarjan neighbour
				node.low_link = min(node.low_link, neighbour.low_link)				
			elsif @stack.include? neighbour
				node.low_link = min(node.low_link, neighbour.index)
			end
		end
		if node.low_link == node.index
			scc = []
			while(@stack.first != node)
				scc << @stack.shift
			end
			scc << @stack.shift
			puts "SCC #{scc.collect{|n| n.id}.inspect}"
			@sub_graphs << scc
		end
	end

	def stack_debug
		@stack.collect{ |wse| wse.id }.inspect
	end

end

=begin
nodes = Graph.hash_to_nodes({ 
 'a'=> ['b','c'], 'b' => ['a', 'c'], 'c' => ['a','b','d'],
 'd' => ['e','f'], 'e' => ['d','f'], 'f' => ['d','e'] 
}).nodes
#nodes = hash_to_nodes({ 'a'=> ['b'], 'b' => ['a']})#, 'c' => ['d'], 'd' => ['c'] })
Tarjan.new(nodes).run
=end

