#!/usr/bin/env ruby
require 'rubygems'
require 'rgl/adjacency'
require 'rgl/connected_components'
require 'parse'
require 'shortest_path'

g = parse_from_stdin
g.each_connected_component do |vertexs| 
	puts vertexs.inspect
end

maximal_edge = g.maximal_between_edge
g.remove_edge *maximal_edge

g.each_connected_component do |vertexs| 
	puts vertexs.inspect
end
