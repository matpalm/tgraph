MaximalEdges = Struct.new :edges, :freq

module RGL
	class AdjacencyGraph
		
		def maximal_between_edges
			max_edges = []
			max_freq = -1 # bootstrap
			puts "edge_betweeness=#{edge_betweeness.inspect}"
			edge_betweeness.each do |edge, freq|
				next unless freq >= max_freq
				max_edges << edge
				max_freq = freq
			end
			MaximalEdges.new max_edges, max_freq
		end

		def edge_betweeness
			edge_freq = Hash.new 0
			vertices.each do |vertex|
				edges = edges_for_shortest_paths_from vertex
				edges.each do |edge|
					edge_freq[edge] += 1 
				end
			end
			edge_freq
		end

		def edges_for_shortest_paths_from vertex1
			raise "vertex #{vertex1.inspect} not a member of this graph" unless member? vertex1
			edges = []
			visited = Set.new
			shortest_path_found = Set.new
			todo = [ vertex1 ]
			while not todo.empty? do
#				puts "\ntodo = #{todo.inspect}"
#				puts "visited = #{visited.inspect}"
#				puts "shortest_path_found = #{shortest_path_found.inspect}"

				vertex1 = todo.shift
#				puts "visiting #{vertex1}"

				visited << vertex1
				shortest_path_found << vertex1

				neighbours = adjacent_vertices vertex1
#				puts "neighbours=#{neighbours.inspect}"
				neighbours.each do |vertex2|
					next if shortest_path_found.include? vertex2
					e = edge_for vertex1, vertex2
					edges << e
#					puts "edge #{e.inspect}"
					shortest_path_found << vertex2
					todo << vertex2 unless visited.include? vertex2
				end
			end
			edges
		end

		def edge_for v1, v2
			v1,v2 = v2,v1 if v2<v1
			[v1,v2]
		end

	end

end

