require File.dirname(__FILE__) + '/core_extensions'

Solution = Struct.new :graph, :edge, :sizes

class Solutions
  
  attr_reader :best

  def initialize
    @best = nil
  end
  
  def consider_candidate graph, edge, sizes
    best_solution = Solution.new graph, edge, sizes

    if @best.nil?
      @best = best_solution
      return
    end
    
    if @best.sizes.size == 1 && sizes.size == 2
      # capture, always favour a best sizes of length 2
      @best = best_solution
    elsif @best.sizes.size == 2 && sizes.size == 1
      # ignore, always favour a best sizes of length 2
    else
      @best = best_solution if sizes.sd < @best.sizes.sd
    end
    
  end

end




