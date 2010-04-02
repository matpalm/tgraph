#!/usr/bin/env ruby
require 'set'
require 'rubygems'
require 'ruby-debug'

Graph = Struct.new :v, :gid, :pgid, :row, :height

class Dendrogramer

  def initialize
    @r_matrix = []
    @r_heights = []
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
        Graph.new *(%w{v gid pgid}.collect { |arg| hash[arg.to_sym] })
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
        puts "PROCESSED #{graph}"
        dump_info
      else
        process_from_other_row graph
        puts "PROCESSED #{graph}"
        dump_info
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
    puts "processing clique #{clique.inspect}"
    a,b = vertices.shift, vertices.shift
    @r_matrix << [ -a, -b ]       
    @r_heights << 1 

    while not vertices.empty?
      b = vertices.shift
      @r_matrix << [ @r_matrix.size, -b ]
      @r_heights << 1 
    end
    
    clique.row = @r_matrix.size
    puts "rows now #{@r_matrix.inspect}"
    puts "clique #{clique.inspect}"
  end

  def children_of parent
    @children[parent.gid].collect { |id| @graphs[id] }
  end

  def process_as_first_row_single_value graph
    graph.row = -graph.v.first
  end
  
  def dump_info
    puts
    @graphs_list.each { |g| puts g.inspect }
    puts "r_matrix #{@r_matrix.inspect}"
    puts "r_heights #{@r_heights.inspect}"
  end

  def output_r_file
    puts 'a <- list()'
    puts "a$merge <- matrix(c(#{@r_matrix.flatten.join ','}), nc=2, byrow=TRUE)"
    puts "a$height <- c(#{@r_heights.join ','})"
    puts "a$order <- 1:#{@r_heights.size+1}"
    puts "a$labels <- 1:#{@r_heights.size+1}"
    puts 'class(a) <- "hclust"'
    puts 'jpeg("test.jpg", width=400, height=400)'
    puts 'plot(as.dendrogram(a))'
    puts 'dev.off()'    
  end

end

=begin
    calculate_graphs_for inputs
    @row = 1
    @r_matrix = []
    @r_heights = []
  end

  def calculate_graphs_for raw_input
    @graphs = {}
    while not raw_input.empty?
      line = raw_input.shift
      last_line = raw_input.empty?
  
      last_line = @inputs = raw_input.reverse.collect do |graphs_at_step|
      graphs_at_step.collect do |graph|
        gid = graph[:gid]
    
      end
    end
    puts ">>graphs"
    @graphs.each do |k,v|
      puts "  #{k} => #{v.inspect}"
    end
    puts "<<graphs"
  end

  def process
    build_children
    allocate_height
    process_initial_cliques
    process_remaining_single_splits
    output_r_file
  end

  def build_children
    @children = {}
    for_each_graph_in_input do |child|
      next if child.gid == 1
      parent_id = @graphs[child.pgid].gid
      @children[parent_id] ||= []
      @children[parent_id] << child unless @children[parent_id].include? child      
    end    
    puts ">>children"
    @children.each do |k,v|
      puts "  #{k.inspect}  =>  #{v.inspect}"
    end
    puts "<<children"

  end

  def allocate_height
    @inputs.each_with_index do |graphs, line_num|
      graphs.each do |graph|
        graph.height ||= line_num+1
      end
    end
    puts "INPUT #{@inputs.inspect}"
  end

  def process_initial_cliques
    first_row = @inputs.shift
    first_row.each do |graph|
      is_clique = graph.v.size > 1
      if is_clique
        process_clique graph
      else
        process_first_row_vertex graph
      end
    end
  end



  def process_first_row_vertex graph
    puts "first row vertex #{graph.inspect}"    
    sibling = sibling_of graph
    puts "sibling is #{sibling.inspect}"    

    add_entry_to_r_matrix [ -graph.v.first, sibling.row ]

    puts "graph_height = #{graph.height}"
    puts "sibling_height = #{sibling.height}"
    @r_heights << [ graph.height, sibling.height].max + 1

    parent = @graphs[graph.pgid]
    parent.row = last_row_number_allocated

    puts "r_matrix  #{@r_matrix.inspect}"
    puts "r_heights #{@r_heights.inspect}"
  end

  def sibling_of graph
    parent_id = @graphs[graph.pgid].gid
    children_of_parent = @children[parent_id]
    raise "logic error" if children_of_parent.nil?
    raise "logic error" unless children_of_parent.include? graph
    children_of_parent.delete graph
    raise "logic error" unless children_of_parent.size == 1
    children_of_parent.first
  end
  
  def process_remaining_single_splits
    for_each_graph_in_input do |graph|
      next if not graph.row.nil?
      puts "processing single split #{graph.inspect}"
      children = @children[graph.gid]
      raise "logic error" unless children.size == 2
      puts "childrens are #{children.inspect}"

      add_entry_to_r_matrix children.collect {|c| c.row}
      graph.row = last_row_number_allocated
      puts "r_matrix now  #{@r_matrix.inspect}"

      children_heights = children.collect(&:height)
      @r_heights << children_heights.max+1
      puts "r_heights now #{@r_heights.inspect}"
    end
  end

  def output_r_file
    puts 'a <- list()'
    puts "a$merge <- matrix(c(#{@r_matrix.flatten.join ','}), nc=2, byrow=TRUE)"
    puts "a$height <- c(#{@r_heights.join ','})"
    puts "a$order <- 1:#{@r_heights.size+1}"
    puts "a$labels <- 1:#{@r_heights.size+1}"
    puts 'class(a) -> "hclust"'
    puts 'jpeg("test.jpg", width=400, height=400)'
    puts 'plot(as.dendrogram(a))'
    puts 'dev.off()'    
  end

  def for_each_graph_in_input    
    @inputs.each do |graphs|
      graphs.each do |graph|
        yield graph
      end
    end
  end

  def add_entry_to_r_matrix row
    @r_matrix << row
    @row += 1
  end

  def last_row_number_allocated
    @row - 1
  end

#  def process_vertices vertices
#    puts ">process_vertices #{vertices.inspect}" 
#  end

#  def process_normal_single_splits
#    puts ">process_normal_single_splits"
#  end
  
end
=end

input = [
         [{:v=>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], :gid=>1, :pgid=>nil}],
         [{:v=>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], :gid=>1, :pgid=>nil}],
         [{:v=>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], :gid=>1, :pgid=>nil}],
         [{:v=>[3, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], :gid=>2, :pgid=>1}, {:v=>[1, 2, 4], :gid=>3, :pgid=>1}],
         [{:v=>[1, 2, 4], :gid=>3, :pgid=>1}, {:v=>[3, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], :gid=>2, :pgid=>1}],
         [{:v=>[1, 2, 4], :gid=>3, :pgid=>1}, {:v=>[3, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], :gid=>2, :pgid=>1}],
         [{:v=>[1, 2, 4], :gid=>3, :pgid=>1}, {:v=>[3, 5, 6, 8, 10, 11, 12, 13, 14], :gid=>4, :pgid=>2}, {:v=>[7, 9], :gid=>5, :pgid=>2}],
         [{:v=>[1, 2, 4], :gid=>3, :pgid=>1}, {:v=>[7, 9], :gid=>5, :pgid=>2}, {:v=>[3, 5, 6, 8, 10, 11, 12, 13, 14], :gid=>4, :pgid=>2}],
         [{:v=>[1, 2, 4], :gid=>3, :pgid=>1}, {:v=>[7, 9], :gid=>5, :pgid=>2}, {:v=>[3, 5, 6, 8, 10, 11, 12, 13, 14], :gid=>4, :pgid=>2}],
         [{:v=>[1, 2, 4], :gid=>3, :pgid=>1}, {:v=>[7, 9], :gid=>5, :pgid=>2}, {:v=>[3, 5, 6, 8], :gid=>6, :pgid=>4}, {:v=>[10, 11, 12, 13, 14], :gid=>7, :pgid=>4}],
         [{:v=>[1, 2, 4], :gid=>3, :pgid=>1}, {:v=>[7, 9], :gid=>5, :pgid=>2}, {:v=>[3, 5, 6, 8], :gid=>6, :pgid=>4}, {:v=>[10, 11, 12, 13, 14], :gid=>7, :pgid=>4}],
         [{:v=>[1, 2, 4], :gid=>3, :pgid=>1}, {:v=>[7, 9], :gid=>5, :pgid=>2}, {:v=>[3, 5, 6, 8], :gid=>6, :pgid=>4}, {:v=>[10, 11, 12, 13, 14], :gid=>7, :pgid=>4}],
         [{:v=>[1, 2, 4], :gid=>3, :pgid=>1}, {:v=>[7, 9], :gid=>5, :pgid=>2}, {:v=>[3, 5, 6, 8], :gid=>6, :pgid=>4}, {:v=>[11], :gid=>8, :pgid=>7}, {:v=>[10, 12, 13, 14], :gid=>9, :pgid=>7}],
         [{:v=>[1, 2, 4], :gid=>3, :pgid=>1}, {:v=>[7, 9], :gid=>5, :pgid=>2}, {:v=>[3, 5, 6, 8], :gid=>6, :pgid=>4}, {:v=>[11], :gid=>8, :pgid=>7}, {:v=>[10, 12, 13, 14], :gid=>9, :pgid=>7}],
         [{:v=>[1, 2, 4], :gid=>3, :pgid=>1}, {:v=>[7, 9], :gid=>5, :pgid=>2}, {:v=>[3, 5, 6, 8], :gid=>6, :pgid=>4}, {:v=>[11], :gid=>8, :pgid=>7}, {:v=>[10, 12, 13], :gid=>10, :pgid=>9}, {:v=>[14], :gid=>11, :pgid=>9}]
]

Dendrogramer.new.process input


