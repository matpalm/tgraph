#!/usr/bin/env ruby

# slurp in stdin and then emit only edges largest connected component

require 'rubygems'
require "rgl/adjacency"
require 'rgl/connected_components'

graph = RGL::AdjacencyGraph.new
STDIN.each do |line|
  v1, v2 = line.chomp.split("\t")
  [v1, v2].each { |v| graph.add_vertex v }
  graph.add_edge v1, v2
end

graph.each_connected_component do |vertices|
  puts vertices.size
end







