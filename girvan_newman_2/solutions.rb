require 'core_extensions'

Solution = Struct.new :edge, :sizes

class Solutions
  
  attr_reader :best

  def initialize
    @best = nil
  end
  
  def add edge, sizes
    if @best.nil?
      @best = Solution.new edge, sizes
      return
    end
    
    if @best.sizes.size == 1 && sizes.size == 2
      # capture, always favour a best sizes of length 2
      @best = Solution.new edge, sizes
    elsif @best.sizes.size == 2 && sizes.size == 1
      # ignore, always favour a best sizes of length 2
    else
      @best = Solution.new edge, sizes if sizes.sd < @best.sizes.sd
    end
    
  end

end




