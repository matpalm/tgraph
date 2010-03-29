class Array
  
  def sd
    average = inject(:+).to_f / size
    square_of_diffs = collect { |e| (e-average)**2 }
    Math.sqrt( square_of_diffs.inject(:+) / size )
  end

  def min
    inject {|a,v| a<v ? a:v }
  end

  def max
    inject {|a,v| a>v ? a:v }
  end

end
