#!/usr/bin/env ruby
require 'rubygems'
require 'rgl/adjacency'
require 'rgl/connected_components'
require 'edge_betweeness'
require 'connected_components_extensions'
require 'core_extensions'
require 'parse'
require 'solutions'

initial_graph = parse_from_stdin
puts "PARTITIONS #{[initial_graph.vertices.sort].inspect}"
graphs = initial_graph.break_into_connected_components

100.times do |i|
  puts "iter #{i}"

  candidate_solutions = Solutions.new
  should_continue = false
  graphs.each do |graph|
    puts "processing graph = #{graph}"
    edge_betweeness = graph.edge_betweeness  
    puts "is clique? #{edge_betweeness.is_clique?}"
    if not edge_betweeness.is_clique?
      puts "not a clique; considering candidate solutions"
      graph.add_maximal_edges_to candidate_solutions
      should_continue = true
    end
  end
  
  if should_continue
    puts "removing best candidate solution from #{candidate_solutions.best}"
    graph, edge = candidate_solutions.best.graph, candidate_solutions.best.edge
    graphs.delete graph
    graph.remove_edge *edge
    graphs += graph.break_into_connected_components
  else
    puts "FINAL final"
    graphs.each { |g| puts g }
    exit 0
  end
 

  partitions = graphs.collect { |g| g.vertices.sort }
  partitions.sort! { |a,b| a.first <=> b.first }
  puts "PARTITIONS #{partitions.inspect}"

end

=begin
5.times do |i|

  
  puts "removing edge #{candidate_solutions.best}"
  g.remove_edge *candidate_solutions.best.edge
  
  puts "breaking graph into it's decomposition"
  decomposition = g.break_into_connected_components
  puts decomposition.inspect
  if decomposition.size > 1
    decomposition.each do |vertices|
      puts "decomposed #{g.clone_retaining_only_vertices vertices}"
    end
    exit 0
  end

end

puts "final"
g.each_connected_component do |vertexs| 
  puts vertexs.inspect
end
=end
