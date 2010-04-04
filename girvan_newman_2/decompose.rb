#!/usr/bin/env ruby
require 'rubygems'
require 'rgl/adjacency'
require 'rgl/connected_components'
require 'json'

['edge_betweeness','connected_components_extensions','core_extensions',
 'parse','solutions'].each { |f| require "#{File.dirname(__FILE__)}/#{f}" }

@partitions = []
def emit_partitions graphs
  partition = graphs.collect do |g| 
    { 
      :v => g.vertices.sort, 
      :gid => g.gid,
      :pgid => g.parent_gid
    }
  end
  @partitions << partition
end

def name_of_node vertex_id
  @node_names[vertex_id-1]
end

initial_graph, @node_names = Parser.new.parse_from_stdin
emit_partitions [initial_graph]

graphs = initial_graph.break_into_connected_components
emit_partitions graphs if graphs.size > 1

100000.times do |i|
  STDERR.puts "i=#{i} #graphs=#{graphs.size}"

  candidate_solutions = Solutions.new
  at_least_one_non_clique = false
  graphs.each do |graph|
    edge_betweeness = graph.edge_betweeness  
    if not edge_betweeness.is_clique?
      graph.add_maximal_edges_to candidate_solutions
      at_least_one_non_clique = true
    end    
  end
  
  if at_least_one_non_clique
    graph, edge = candidate_solutions.best.graph, candidate_solutions.best.edge
    graphs.delete graph
    STDERR.puts "removing edge #{name_of_node(edge[0])} #{name_of_node(edge[1])}"
    graph.remove_edge *edge
    graph.edge_betweeness = nil
    graphs += graph.break_into_connected_components

    # debug
#    sizes = []
#    graphs.each do |graph|
#      graph.each_connected_component { |vertices| sizes << vertices.length }
#    end
#    STDERR.puts sizes.inspect

  else
    puts({ :partitions => @partitions, :node_names => @node_names}.to_json)
    exit 0
  end
 
  emit_partitions graphs

end

