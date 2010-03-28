class Array

	def sd
		average = inject(:+).to_f / size
		square_of_diffs = collect { |e| (e-average)**2 }
		puts "average=#{average} square_of_diffs=#{square_of_diffs}"
		Math.sqrt( square_of_diffs.inject(:+) / size )
	end

end
