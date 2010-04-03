#!/usr/bin/env ruby
require 'set'
require 'rubygems'
require 'json'

Graph = Struct.new :v, :gid, :pgid, :row, :height

class Dendrogramer

  def initialize node_names
    @r_matrix = []
    @r_heights = []
    @node_names = node_names
  end

  def process raw_inputs
    inputs = convert_raw_input raw_inputs.reverse
    inject_heights_into inputs
    @graphs_list = inputs.flatten
    remove_duplicate_entries
    build_graph_hierarchy
    process_lines
    output_r_file
  end

  def convert_raw_input inputs
    inputs.collect do |line|
      line.collect do |hash|
        Graph.new *(%w{v gid pgid}.collect { |arg| hash[arg] })
      end     
    end
  end    
  
  def inject_heights_into inputs
    inputs.each_with_index do |line, line_number|
      line.each do |graph|
        graph.height = line_number+1
      end
    end
  end
  
  def remove_duplicate_entries
    height_1, height_other = @graphs_list.partition { |g| g.height == 1}

    seen_gids = Set.new
    seen_gids += height_1.collect(&:gid)

    to_retain_from_others = []
    height_other.reverse.each do |graph|
      if not seen_gids.include? graph.gid
        to_retain_from_others << graph
        seen_gids << graph.gid
      end
    end

    @graphs_list = height_1 + to_retain_from_others.reverse
  end

  def build_graph_hierarchy
    @graphs = {}
    @children = Hash.new{|h, k| h[k] = []}

    @graphs_list.each do |graph|
      @graphs[graph.gid] = graph
      @children[graph.pgid] << graph.gid
    end
  end

  def process_lines
    @graphs_list.each do |graph|
      if graph.height==1
        process_from_first_row graph
#        puts "PROCESSED #{graph}"
#        dump_info
      else
        process_from_other_row graph
#        puts "PROCESSED #{graph}"
#        dump_info
      end
    end
  end

  def process_from_first_row graph
    if graph.v.size > 1
      process_as_first_row_clique graph
    else
      process_as_first_row_single_value graph
    end
  end

  def process_from_other_row graph
    children = children_of graph
    @r_matrix << children.collect(&:row)
    graph.row = @r_matrix.size
    @r_heights << graph.height
  end

  def process_as_first_row_clique clique
    vertices = clique.v.clone
    a,b = vertices.shift, vertices.shift
    @r_matrix << [ -a, -b ]       
    @r_heights << 1 

    while not vertices.empty?
      b = vertices.shift
      @r_matrix << [ @r_matrix.size, -b ]
      @r_heights << 1 
    end
    
    clique.row = @r_matrix.size
  end

  def children_of parent
    @children[parent.gid].collect { |id| @graphs[id] }
  end

  def process_as_first_row_single_value graph
    graph.row = -graph.v.first
  end
  
  def dump_info
    @graphs_list.each { |g| puts g.inspect }
    puts "r_matrix #{@r_matrix.inspect}"
    puts "r_heights #{@r_heights.inspect}"
  end

  def output_r_file
    puts 'a <- list()'
    puts "a$merge <- matrix(c(#{@r_matrix.flatten.join ','}), nc=2, byrow=TRUE)"
    puts "a$height <- c(#{@r_heights.join ','})"
    puts "a$order <- 1:#{@r_heights.size+1}"
    #puts "a$labels <- 1:#{@r_heights.size+1}"
    puts "a$labels <- c(\"#{@node_names.join('","')}\")"
    puts 'class(a) <- "hclust"'
    puts "jpeg(\"#{ARGV.first || 'dendrogram'}.jpg\", width=400, height=400)"
    puts 'plot(as.dendrogram(a))'
    puts 'dev.off()'    
  end

end

input = JSON::parse(STDIN.readline)
partitions = input['partitions']
node_names = input['node_names']
Dendrogramer.new(node_names).process partitions


