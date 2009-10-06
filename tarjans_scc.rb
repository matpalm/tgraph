#!/usr/bin/env ruby
# tarjans strongly connected components algorithm

require 'node'
require 'graph'

class Node
	attr_accessor :index, :low_link
end

class Tarjan

	def initialize nodes
		@nodes = nodes
		@index = 0
		@stack = []
	end
	
	def min a, b
		a < b ? a : b
	end

	def run
		@nodes.each do |node|
			tarjan(node) if node.index.nil?
		end
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
				scc << @stack.shift.id
			end
			scc << @stack.shift.id
			puts "SCC #{scc.inspect}"
		end
	end

	def stack_debug
		@stack.collect{ |wse| wse.id }.inspect
	end

end

nodes = Graph.hash_to_nodes({ 
 'a'=> ['b','c'], 'b' => ['a', 'c'], 'c' => ['a','b','d'],
 'd' => ['e','f'], 'e' => ['d','f'], 'f' => ['d','e'] 
}).nodes
#nodes = hash_to_nodes({ 'a'=> ['b'], 'b' => ['a']})#, 'c' => ['d'], 'd' => ['c'] })
Tarjan.new(nodes).run

