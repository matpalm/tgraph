class Graph

	def initialize nodes
		@nodes = nodes
	end

	def nodes
		@nodes.values
	end

	def self.nodes_from_file filename
		nodes_hash = {}
		File.open(filename).each do |edge|
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
		Graph.new nodes.values
	end

	# edges = [ ['a','b'], ['a',e'], ['b','d'] ]
  # removed neighbours b and e from a and d from b
	def remove_edges edges
		edges.each do |edge|
			from,to = edge
			@nodes[from].remove_neighbour @nodes[to]
		end
	end

	def single_node?
		@nodes.size == 1
	end

	def dump		
		@nodes.collect do |node|
			"#{node.id} => #{node.neighbours.collect{|n| n.id}.inspect}"
		end.join ', '
	end

end
