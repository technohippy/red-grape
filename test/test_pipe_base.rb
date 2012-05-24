require 'test/unit'
require 'red_grape'

class PipeBaseTest < Test::Unit::TestCase
  def setup
    @graph = RedGrape.load_graph 'data/graph-example-1.xml'
  end
  
  def test_to_s
    assert_equal %w(vadas josh lop).to_s, @graph.v(1).out.name.to_s
  end
end

