#!/usr/bin/env ruby
require 'rubygems'
require "rgl/adjacency"

class Parser

  def initialize
    @node_to_vertex_id = {}
    @seq = 1
    @node_names = []
  end

  def vertex_id_for node
    if @node_to_vertex_id.has_key? node
      @node_to_vertex_id[node]
    else
      @node_to_vertex_id[node] = @seq
      @node_names << node
      @seq += 1
      @seq - 1
    end
  end

  def parse_from_stdin
    graph = RGL::AdjacencyGraph.new
    node_names = {}
    STDIN.each do |line|
      v1, v2 = line.chomp.split("\t").collect{ |node| vertex_id_for node }        
      raise "blank vertexs names not allowed!!! #{line}" if v1.nil? || v2.nil?
      [v1, v2].each { |v| graph.add_vertex v }
      graph.add_edge v1, v2
    end	
    [ graph, @node_names ]
  end
 
end


