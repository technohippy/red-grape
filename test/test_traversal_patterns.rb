require 'test/unit'
require 'red_grape'

class TraversalPatternsTest < Test::Unit::TestCase
  def setup
    @graph = RedGrape.load_graph 'data/graph-example-1.xml'
  end

  # https://github.com/tinkerpop/gremlin/wiki/Backtrack-Pattern
  def test_backtrack_pattern
    assert_equal [29], @graph.V.out('knows').has('age', :gt, 30).back(2).age.take
    #assert_equal 29, @graph.V.as('x').outE('knows').inV.has('age', :gt, 30).back('x').age
  end
end
