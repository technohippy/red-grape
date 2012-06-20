require 'test/unit'
require 'red_grape'

class CountPipeTest < Test::Unit::TestCase
  def setup
    @g1 = RedGrape.load_graph 'data/graph-example-1.xml'
  end

  def test_count
    assert_equal 6, @g1.V.count[]
    assert_equal 3, @g1.v(1).out.count[]
  end
end
