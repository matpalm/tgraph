module Graph

	def self.nodes_from_stream stream
		nodes_hash = {}
		stream.each do |edge|
			from,to = edge.strip.split("\t")
			nodes_hash[from] ||= []
			nodes_hash[from] << to	
		end
		hash_to_nodes nodes_hash
	end

	def self.hash_to_nodes nodes_hash
		node_keys = (nodes_hash.keys + nodes_hash.values).flatten.uniq
		nodes_key_to_node = {}
		node_keys.each { |nk| nodes_key_to_node[nk] = Node.new nk}
		nodes = {}
		nodes_hash.keys.sort.each do |node_key|
			neighbours_key = nodes_hash[node_key]
			node = nodes_key_to_node[node_key]
			node.neighbours = neighbours_key.collect {|ns| nodes_key_to_node[ns]}
			nodes[node_key] = node
		end
		nodes.values.each { |n| puts n }
		nodes.values
	end

end

class Array

	# edges = [ ['a','b'], ['a',e'], ['b','d'] ]
  # removed neighbours b and e from a and d from b
	def remove_edges edges
		edges.each { |edge| remove_edge edge } 
	end

	def remove_edge edge
		from_id, to_id = edge
		from = find {|n| n.id==from_id }
		to = find {|n| n.id==to_id }
		from.remove_neighbour to
	end

end
