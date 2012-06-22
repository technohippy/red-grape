require 'test/unit'
require 'red_grape'

class OrderPipeTest < Test::Unit::TestCase
  def setup
    @g1 = RedGrape.load_graph 'data/graph-example-1.xml'
  end

  def test_select
    assert_equal '[v[2], v[3], v[4]]', @g1.v(1).as('v1').out.order[].to_s
  end
end

