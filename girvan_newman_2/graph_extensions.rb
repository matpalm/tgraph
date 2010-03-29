require 'rubygems'
require 'rgl/adjacency'
require 'rgl/connected_components'

module RGL
  class AdjacencyGraph

    def break_into_connected_components
      graphs = []
      each_connected_component do |vertices|
        graphs << clone_retaining_only(vertices)
      end
      graphs
    end

    def clone_retaining_only vertices
      cloned = self.clone
      cloned.vertices.each do |vertex|
        cloned.remove_vertex vertex unless vertices.include? vertex
      end
      cloned
    end

  end

end
