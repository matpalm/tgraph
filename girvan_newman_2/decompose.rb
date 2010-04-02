#!/usr/bin/env ruby
require 'rubygems'
require 'rgl/adjacency'
require 'rgl/connected_components'
require 'json'

['edge_betweeness','connected_components_extensions','core_extensions',
 'parse','solutions'].each { |f| require "#{File.dirname(__FILE__)}/#{f}" }

@output = []
def emit_partitions graphs
  partitions = graphs.collect do |g| 
    { 
      :v => g.vertices.sort, 
      :gid => g.gid,
      :pgid => g.parent_gid
    }
  end
  @output << partitions.clone
end

initial_graph = parse_from_stdin
emit_partitions [initial_graph]

graphs = initial_graph.break_into_connected_components
emit_partitions graphs if graphs.size > 1

1000.times do |i|
  candidate_solutions = Solutions.new
  should_continue = false
  graphs.each do |graph|
    edge_betweeness = graph.edge_betweeness  
    if not edge_betweeness.is_clique?
      graph.add_maximal_edges_to candidate_solutions
      should_continue = true
    end
    
  end
  
  if should_continue
    graph, edge = candidate_solutions.best.graph, candidate_solutions.best.edge
    graphs.delete graph
    graph.remove_edge *edge
    graph.edge_betweeness = nil
    graphs += graph.break_into_connected_components
  else
    puts @output.to_json
    exit 0
  end
 
  emit_partitions graphs

end

