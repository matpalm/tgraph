class Array

	def sd
		average = inject(:+).to_f / size
		square_of_diffs = collect { |e| (e-average)**2 }
		Math.sqrt( square_of_diffs.inject(:+) / size )
	end

end
