#!/usr/bin/env ruby
require 'rubygems'
require 'rgl/adjacency'
require 'rgl/connected_components'
require 'parse'
require 'edge_betweeness'
require 'core_extensions'
require 'graph_extensions'
require 'solutions'

g = parse_from_stdin

5.times do |i|
  
  puts "iter #{i} processing graph #{g}"

  edge_betweeness = g.edge_betweeness
  maximal_edges = edge_betweeness.maximal_edges
  puts "maximal_edges=#{maximal_edges.inspect}"
  
  candidate_solutions = Solutions.new
  maximal_edges.edges.each do |candidate_edge_to_remove|
    
    g.remove_edge *(candidate_edge_to_remove)
    
    sizes = []
    g.each_connected_component do |vertexs| 
      sizes << vertexs.size
      # note: to build a graph from this list can clone original
      #       graph and then remove all vertices BUT these ones
    end
    candidate_solutions.add candidate_edge_to_remove, sizes
    puts "trialing candidate_edge_to_remove=#{candidate_edge_to_remove.inspect}, sizes=#{sizes.inspect}"
    
    g.add_edge *(candidate_edge_to_remove)
    
  end
  
  puts "removing edge #{candidate_solutions.best}"
  g.remove_edge *candidate_solutions.best.edge
  
  puts "breaking graph into it's decomposition"
  decomposition = g.break_into_connected_components
  puts decomposition.inspect
=begin
  if decomposition.size > 1
    decomposition.each do |vertices|
      puts "decomposed #{g.clone_retaining_only_vertices vertices}"
    end
    exit 0
  end
=end
end

puts "final"
g.each_connected_component do |vertexs| 
  puts vertexs.inspect
end
