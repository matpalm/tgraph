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
      maximal_edges.edges.shuffle.each do |candidate_edge_to_remove|
        remove_edge *(candidate_edge_to_remove)
        
        sizes = []
        each_connected_component do |vertexs| 
          sizes << vertexs.size
          # note: to build a graph from this list can clone original
          #       graph and then remove all vertices BUT these ones
        end
        candidate_solutions.consider_candidate self, candidate_edge_to_remove, sizes
        
        add_edge *(candidate_edge_to_remove)
      end
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

      cloned
    end

  end

end
