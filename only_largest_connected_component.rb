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

max_size = 1
vertices_for_biggest_subgraph = nil
graph.each_connected_component do |vertices|
  if vertices.length > max_size
    max_size = vertices.length
    vertices_for_biggest_subgraph = vertices
  end
end

vertices_to_remove = graph.vertices - vertices_for_biggest_subgraph
vertices_to_remove.each { |v| graph.remove_vertex v }

graph.each_edge do |v1,v2|
  v1,v2 = v2,v1 unless v1 < v2
  puts "#{v1}\t#{v2}"
end






