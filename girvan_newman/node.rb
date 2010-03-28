class Node
	
	attr_accessor :id, :neighbours

	def initialize id
		@id = id
	end

	def neighbour_ids
		@neighbours.collect { |n| n.id }
	end

	def remove_neighbour to
		@neighbours.delete to
	end

	def to_s
		"id=#{id} neighbours=#{neighbours.collect{|n|n.id}.inspect}"
	end

end

