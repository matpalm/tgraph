require 'graph_extensions'

describe 'graph_extensions' do

  before :each do
    @g = RGL::AdjacencyGraph.new
    @v_set1 = [1,2,3]
    @v_set2 = [4,5,6]
    
    @e_set1 = [[1,2],[2,3],[3,1]]
    @e_set2 = [[4,5],[5,6],[6,4]]

    (@v_set1 + @v_set2).each { |v| @g.add_vertex v }
    (@e_set1 + @e_set2).each { |e| @g.add_edge *e }

  end

  it 'should break graph up' do

    g1 = @g.clone_retaining_only @v_set1
    g1.vertices.size.should == 3
    g1.edges.size.should == 3
    @v_set1.each { |v| fail unless g1.vertices.include? v }
    @e_set1.each { |e| fail unless g1.has_edge? *e }

    g2 = @g.clone_retaining_only @v_set2
    g2.vertices.size.should == 3
    g2.edges.size.should == 3
    @v_set2.each { |v| fail unless g2.vertices.include? v }
    @e_set2.each { |e| fail unless g2.has_edge? *e }

  end

  describe 'knows how to calculate the sizes of connected components' do

    it 'for even sized partitoning' do
      @g.add_edge 1,4
      @g.sizes_of_connected_components_if_edge_removed([1,4]).should == [3,3]
    end

    it 'for uneven sized' do
      @g.add_vertex 10
      @g.add_vertex 11
      @g.add_edge 10,11
      @g.add_edge 4,10
      @g.sizes_of_connected_components_if_edge_removed([4,10]).sort.should == [2,3,3]
    end

  end
  
end
