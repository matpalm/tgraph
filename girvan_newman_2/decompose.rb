#!/usr/bin/env ruby
require 'rubygems'
require 'rgl/adjacency'
require 'rgl/connected_components'

['edge_betweeness','connected_components_extensions','core_extensions',
 'parse','solutions'].each { |f| require "#{File.dirname(__FILE__)}/#{f}" }

def emit_partitions graphs
  partitions = graphs.collect do |g| 
    { 
      :v => g.vertices.sort, 
      :gid => g.gid,
      :pgid => g.parent_gid
    }
  end
  puts "PART #{partitions.inspect}"
end

initial_graph = parse_from_stdin
emit_partitions [initial_graph]

graphs = initial_graph.break_into_connected_components
emit_partitions graphs if graphs.size > 1

1000.times do |i|
  puts "iter #{i}"

  candidate_solutions = Solutions.new
  should_continue = false
  graphs.each do |graph|
    puts "processing graph gid=#{graph.gid} #{graph.vertices.sort.inspect}"
    edge_betweeness = graph.edge_betweeness  
    if not edge_betweeness.is_clique?
      puts "not a clique; considering candidate solutions"
      graph.add_maximal_edges_to candidate_solutions
      should_continue = true
    else
      puts "is a clique; ignore"
    end
    
  end
  
  if should_continue
    puts "removing best candidate solution from gid=#{candidate_solutions.best.graph.gid}"
    graph, edge = candidate_solutions.best.graph, candidate_solutions.best.edge
    graphs.delete graph
    graph.remove_edge *edge
    graph.edge_betweeness = nil
    graphs += graph.break_into_connected_components
  else
    puts "FINAL final"
    graphs.each { |g| puts g }
    exit 0
  end
 
  emit_partitions graphs

#  partitions.sort! { |a,b| a.first <=> b.first }
 # puts "PARTITIONS #{partitions.inspect}"

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
