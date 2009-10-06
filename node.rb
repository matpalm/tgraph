class Node
	
	attr_accessor :id, :neighbours

	def initialize id
		@id = id
	end

	def neighbour_ids
		@neighbours.collect { |n| n.id }
	end

	def remove_neighbour to
		@neighbours -= [to]
	end

end

