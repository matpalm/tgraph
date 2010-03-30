require 'rubygems'
require 'rgl/adjacency'
require 'rgl/connected_components'

module RGL
  class AdjacencyGraph

    def add_maximal_edges_to candidate_solutions
      maximal_edges = edge_betweeness.maximal_edges    
      puts "maximal_edges=#{maximal_edges.inspect}"
      
      maximal_edges.edges.each do |candidate_edge_to_remove|
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

      puts "best edge to remove from candidates is #{candidate_solutions.best}"
    end
      
    def break_into_connected_components
      graphs = []
      each_connected_component do |vertices|
        graphs << clone_retaining_only(vertices)
      end
      graphs
    end

    def clone_retaining_only vertices
      cloned = self.clone
      cloned.edge_betweeness = nil
      cloned.vertices.each do |vertex|
        cloned.remove_vertex vertex unless vertices.include? vertex
      end
      cloned
    end

    def sizes_of_connected_components_if_edge_removed edge
      raise "graph doesnt have edge #{edge.inspect}" unless has_edge? *edge
      remove_edge *edge
      
      sizes = []
      each_connected_component do |vertexs| 
        sizes << vertexs.size
        # note: to build a graph from this list can clone original
        #       graph and then remove all vertices BUT these ones
      end
      puts "trialing candidate_edge_to_remove=#{edge.inspect}, sizes=#{sizes.inspect}"
      
      add_edge *edge
      sizes
    end

  end

end
