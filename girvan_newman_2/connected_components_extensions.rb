require 'rubygems'
require 'rgl/adjacency'
require 'rgl/connected_components'

module RGL
  class AdjacencyGraph

    attr_writer :gid
    attr_accessor :parent_gid

    def gid
      return @gid if @gid
      @@gid_seq ||= 0  
      @@gid_seq += 1
      @gid = @@gid_seq
    end

    def add_maximal_edges_to candidate_solutions
      maximal_edges = edge_betweeness.maximal_edges
      puts "maximal_edges=#{maximal_edges.inspect}"
      
      maximal_edges.edges.shuffle.each do |candidate_edge_to_remove|
        puts "trialing candidate_edge_to_remove=#{candidate_edge_to_remove.inspect}"
        remove_edge *(candidate_edge_to_remove)
        
        sizes = []
        each_connected_component do |vertexs| 
          sizes << vertexs.size
          # note: to build a graph from this list can clone original
          #       graph and then remove all vertices BUT these ones
        end
        puts "removal of candidate edge results in sizes=#{sizes.inspect}"
        candidate_solutions.consider_candidate self, candidate_edge_to_remove, sizes
        
        add_edge *(candidate_edge_to_remove)
      end

      puts "best edge to remove from candidates is gid=#{candidate_solutions.best.graph.gid} edge=#{candidate_solutions.best.edge.inspect}"
    end
      
    def break_into_connected_components
      graphs = []
      each_connected_component do |vertices|
        graphs << clone_retaining_only(vertices)
      end
      graphs
    end

    def clone_retaining_only vertices
      return self if vertices.sort == self.vertices.sort
 
      cloned = self.clone
       cloned.vertices.each do |vertex|
        cloned.remove_vertex vertex unless vertices.include? vertex
      end

      cloned.gid = nil
      cloned.parent_gid = self.gid

      puts "cloned #{gid} to make #{cloned.gid}"
      cloned
    end

  end

end
