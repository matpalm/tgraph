require 'solutions'

describe 'solutions' do
  
  before do
    @solutions = Solutions.new
  end
  
  it 'remember the first, whatever it is' do
    @solutions.consider_candidate :graph, :edge, [1,2,3]
    @solutions.best.graph.should == :graph
    @solutions.best.edge.should == :edge
    @solutions.best.sizes.should == [1,2,3]
  end
  
  it 'remember the first of two single arrays' do
    @solutions.consider_candidate :graph, :edge1, [1]
    @solutions.consider_candidate :graph, :edge2, [13]
    @solutions.best.graph.should == :graph
    @solutions.best.edge.should == :edge1
    @solutions.best.sizes.should == [1]
  end
  
  it 'remember an array of two elements over an array of a single element' do
    @solutions.consider_candidate :graph1, :edge, [1]
    @solutions.consider_candidate :graph2, :edge, [1,2]
    @solutions.best.graph.should == :graph2
    @solutions.best.edge.should == :edge
    @solutions.best.sizes.should == [1,2]
  end
  
  it 'remember the array of two elements with the lowest standard deviation' do
    @solutions.consider_candidate :graph, :edge1, [10,4]
    @solutions.consider_candidate :graph, :edge2, [4,4]
    @solutions.consider_candidate :graph, :edge3, [4,9]
    @solutions.best.graph.should == :graph
    @solutions.best.edge.should == :edge2
    @solutions.best.sizes.should == [4,4]
  end
  
end

